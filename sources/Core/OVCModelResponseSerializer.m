// OVCModelResponseSerializer.m
//
// Copyright (c) 2013 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OVCModelResponseSerializer.h"
#import <Mantle/Mantle.h>
#import "OVCResponse.h"
#import "OVCURLMatcher.h"
#import "NSError+OVCResponse.h"
#import <objc/runtime.h>

@interface OVCModelResponseSerializer ()

@property (strong, nonatomic) OVCURLMatcher *URLMatcher;
@property (strong, nonatomic) OVCURLMatcher *URLResponseClassMatcher;
@property (nonatomic) Class responseClass;
@property (nonatomic) Class errorModelClass;

@end

#pragma mark - Patch AFNetworking

/*
 * To make the URL Matcher works with request content like http method used,
 * the response serializer must be able to access its corresponding reqeust.
 *
 * Hence we patch AFNetworking to associate responses with its reqeust.
 * 
 * 1. `NSAssert`s are added in order that AFNetworking are changing its API.
 * 2. `-[AFURLSessionManagerTaskDelegate URLSession:task:didCompleteWithError:]` calls response serializer
 *    asynchronously, so the clean up action could be only called in the completion handler.
 *
 */

typedef void (^ovc_AFURLSessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);
@interface ovc_dummy_AFURLSessionManagerTaskDelegate : NSObject
@property (nonatomic, copy) ovc_AFURLSessionTaskCompletionHandler completionHandler;
@end

@implementation OVCModelResponseSerializer (AFNetworkingPatch)

static char OVC_NSURLSessionTask_requestAssociationKey;
typedef void (*__imp_URLSession_task_didCompleteWithError_)(id, SEL, NSURLSession *, NSURLSessionTask *, NSError *);
static __imp_URLSession_task_didCompleteWithError_ __af_URLSession_task_didCompleteWithError_;
void __ovc_URLSession_task_didCompleteWithError_(ovc_dummy_AFURLSessionManagerTaskDelegate *self,
                                                 SEL _cmd,
                                                 NSURLSession *session,
                                                 NSURLSessionTask* task,
                                                 NSError *error) {
    Class AFURLSessionManagerTaskDelegate = NSClassFromString(@"AFURLSessionManagerTaskDelegate");
    NSAssert([self isKindOfClass:AFURLSessionManagerTaskDelegate],
             @"Check Overcoat update for this issue. "
             @"Or submit one to https://github.com/Overcoat/Overcoat/issues");
    NSAssert([NSStringFromSelector(_cmd) isEqualToString:@"URLSession:task:didCompleteWithError:"],
             @"Check Overcoat update for this issue. "
             @"Or submit one to https://github.com/Overcoat/Overcoat/issues");

    // Associate the task to its response ... to make the URLMatcher able to access request
    NSURLResponse *response = task.response;
    NSURLRequest *request = task.currentRequest;
    if (response && request) {
        objc_setAssociatedObject(response,
                                 &OVC_NSURLSessionTask_requestAssociationKey,
                                 request,
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        // Clean up associated object in completion handler
        ovc_AFURLSessionTaskCompletionHandler completionHandler = self.completionHandler;
        self.completionHandler = ^(NSURLResponse *response, id responseObject, NSError *error) {
            if (response) {
                objc_setAssociatedObject(response,
                                         &OVC_NSURLSessionTask_requestAssociationKey,
                                         nil,
                                         OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }

            if (completionHandler) {
                completionHandler(response, responseObject, error);
            }
        };
    }

    // Call original implementation
    __af_URLSession_task_didCompleteWithError_(self, _cmd, session, task, error);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class AFURLSessionManagerTaskDelegate = NSClassFromString(@"AFURLSessionManagerTaskDelegate");
        NSAssert(AFURLSessionManagerTaskDelegate, @"Cannot find class `AFURLSessionManagerTaskDelegate`. "
                 @"Check Overcoat update for this issue. "
                 @"Or submit one to https://github.com/Overcoat/Overcoat/issues");
        SEL originalSelector = @selector(URLSession:task:didCompleteWithError:);
        NSAssert([AFURLSessionManagerTaskDelegate instancesRespondToSelector:originalSelector],
                 @"AFURLSessionManagerTaskDelegate doesn't responds to URLSession:task:didCompleteWithError:. "
                 @"Check Overcoat update for this issue. "
                 @"Or submit one to https://github.com/Overcoat/Overcoat/issues");

        Method originalMethod = class_getInstanceMethod(AFURLSessionManagerTaskDelegate, originalSelector);
        IMP swizzleImp = (IMP)__ovc_URLSession_task_didCompleteWithError_;
        __af_URLSession_task_didCompleteWithError_ =
            (__imp_URLSession_task_didCompleteWithError_)method_setImplementation(originalMethod, swizzleImp);
        NSAssert(__af_URLSession_task_didCompleteWithError_,
                 @"Check Overcoat update for this issue. "
                 @"Or submit one to https://github.com/Overcoat/Overcoat/issues");
    });
}

@end

#pragma mark - Serializer Implementation

@implementation OVCModelResponseSerializer

+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)URLMatcher
                 responseClassURLMatcher:(OVCURLMatcher *)URLResponseClassMatcher
                           responseClass:(Class)responseClass
                         errorModelClass:(Class)errorModelClass {
    return [[self alloc] initWithURLMatcher:URLMatcher
                    responseClassURLMatcher:URLResponseClassMatcher
                              responseClass:responseClass
                            errorModelClass:errorModelClass];
}

- (instancetype)init {
    return [self initWithURLMatcher:[[OVCURLMatcher alloc] initWithBasePath:nil modelClassesByPath:nil]
            responseClassURLMatcher:nil
                      responseClass:[OVCResponse class]
                    errorModelClass:nil];
}

- (instancetype)initWithURLMatcher:(OVCURLMatcher *)URLMatcher
           responseClassURLMatcher:(OVCURLMatcher *)URLResponseClassMatcher
                     responseClass:(Class)responseClass
                   errorModelClass:(Class)errorModelClass {
    NSParameterAssert([responseClass isSubclassOfClass:[OVCResponse class]]);

    if (errorModelClass != Nil) {
        NSParameterAssert([errorModelClass conformsToProtocol:@protocol(MTLModel)]);
    }

    if (self = [super init]) {
        self.jsonSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:0];

        self.URLMatcher = URLMatcher;
        self.URLResponseClassMatcher = URLResponseClassMatcher;
        self.responseClass = responseClass;
        self.errorModelClass = errorModelClass;
    }
    return self;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    NSError *serializationError = nil;
    id OVC__NULLABLE JSONObject = [self.jsonSerializer responseObjectForResponse:response
                                                                            data:data
                                                                           error:&serializationError];

    if (error) {
        *error = serializationError;
    }

    if (serializationError && serializationError.code != NSURLErrorBadServerResponse) {
        return nil;
    }

    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSURLRequest *request = response ? objc_getAssociatedObject(response,
                                                                &OVC_NSURLSessionTask_requestAssociationKey) : nil;
    Class resultClass = Nil;
    Class responseClass = Nil;

    if (!serializationError) {
        resultClass = [self.URLMatcher modelClassForURLRequest:request andURLResponse:HTTPResponse];

        if (self.URLResponseClassMatcher) {
            responseClass = [self.URLResponseClassMatcher modelClassForURLRequest:request andURLResponse:HTTPResponse];
        }

        if (!responseClass) {
            responseClass = self.responseClass;
        }
    } else {
        resultClass = self.errorModelClass;
        responseClass = self.responseClass;
    }

    OVCResponse *responseObject = [responseClass responseWithHTTPResponse:HTTPResponse
                                                               JSONObject:JSONObject
                                                              resultClass:resultClass
                                                                    error:&serializationError];
    if (serializationError && error) {
        *error = serializationError;
    }

    return responseObject;
}

- (NSSet *)acceptableContentTypes {
    return self.jsonSerializer.acceptableContentTypes;
}

- (NSIndexSet *)acceptableStatusCodes {
    return self.jsonSerializer.acceptableStatusCodes;
}

- (NSStringEncoding)stringEncoding {
    return self.jsonSerializer.stringEncoding;
}

@end
