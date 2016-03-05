// OVCHTTPSessionManager.m
//
// Copyright (c) 2013-2016 Overcoat Team
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

#import "OVCHTTPSessionManager.h"
#import "OVCResponse.h"
#import "OVCModelResponseSerializer.h"
#import "OVCURLMatcher.h"
#import "NSError+OVCResponse.h"

@implementation OVCHTTPSessionManager

#if DEBUG
+ (void)initialize {
    // TODO: Add links to releated document.
    if ([self respondsToSelector:@selector(errorModelClass)]) {
        NSLog(@"Warning: `+[OVCHTTPSessionManager errorModelClass]` is deprecated. "
              @"Override `+[OVCHTTPSessionManager errorModelClassesByResourcePath]` instead. (Class: %@)", self);
    }
    if ([self respondsToSelector:@selector(responseClass)]) {
        NSLog(@"Warning: `+[OVCHTTPSessionManager responseClass]` is deprecated. "
              @"Override `+[OVCHTTPSessionManager responseClassesByResourcePath]` instead. (Class: %@)", self);
    }
}
#endif

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        self.responseSerializer =
        [OVCModelResponseSerializer
         serializerWithURLMatcher:[OVCURLMatcher matcherWithBasePath:self.baseURL.path
                                                  modelClassesByPath:[[self class] modelClassesByResourcePath]]
         responseClassURLMatcher:[OVCURLMatcher matcherWithBasePath:self.baseURL.path
                                                 modelClassesByPath:[[self class] responseClassesByResourcePath]]
         errorModelClassURLMatcher:[OVCURLMatcher matcherWithBasePath:self.baseURL.path
                                                   modelClassesByPath:[[self class] errorModelClassesByResourcePath]]];
    }
    return self;
}

#pragma mark - HTTP Manager Protocol

+ (NSDictionary *)modelClassesByResourcePath {
    [NSException
     raise:NSInternalInconsistencyException
     format:@"+[%@ %@] should be overridden by subclass", NSStringFromClass(self), NSStringFromSelector(_cmd)];
    return nil;  // Not reached
}

+ (NSDictionary *)responseClassesByResourcePath {
    return @{@"**": [OVCResponse class]};
}

+ (NSDictionary *)errorModelClassesByResourcePath {
    return nil;
}

#pragma mark - Making requests

- (NSURLSessionDataTask *)_dataTaskWithHTTPMethod:(NSString *)method
                                        URLString:(NSString *)URLString
                                       parameters:(id)parameters
                                       completion:(void (^)(OVCResponse *, NSError *))completion {
    // The implementation is copied from AFNetworking ... (Since we want to pass `responseObject`)
    // (Superclass implemenration doesn't return response object.)

    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer
                                    requestWithMethod:method
                                    URLString:[NSURL URLWithString:URLString relativeToURL:self.baseURL].absoluteString
                                    parameters:parameters
                                    error:&serializationError];
    if (serializationError) {
        if (completion) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                completion(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }

    return [self dataTaskWithRequest:request
                   completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                       if (completion) {
                           if (!error) {
                               completion(responseObject, nil);
                           } else {
                               error = [error ovc_errorWithUnderlyingResponse:responseObject];
                               completion(responseObject, error);
                           }
                       }
                   }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(void (^)(OVCResponse *, NSError *))completion {
    NSURLSessionDataTask *task = [self _dataTaskWithHTTPMethod:@"GET"
                                                     URLString:URLString
                                                    parameters:parameters
                                                    completion:completion];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(id)parameters
                    completion:(void (^)(OVCResponse *, NSError *))completion {
    NSURLSessionDataTask *task = [self _dataTaskWithHTTPMethod:@"HEAD"
                                                     URLString:URLString
                                                    parameters:parameters
                                                    completion:completion];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                    completion:(void (^)(OVCResponse *, NSError *))completion {
    NSURLSessionDataTask *task = [self _dataTaskWithHTTPMethod:@"POST"
                                                     URLString:URLString
                                                    parameters:parameters
                                                    completion:completion];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                    completion:(void (^)(OVCResponse *, NSError *))completion {
    // The implementation is copied from AFNetworking ... (Since we want to pass `responseObject`)
    // (Superclass implemenration doesn't return response object.)

    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:[NSURL URLWithString:URLString relativeToURL:self.baseURL].absoluteString
                                    parameters:parameters
                                    constructingBodyWithBlock:block
                                    error:&serializationError];
    if (serializationError) {
        if (completion) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                completion(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        return nil;
    }
    
    // `dataTaskWithRequest:completionHandler:` creates a new NSURLSessionDataTask
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:request
                                             completionHandler:^(NSURLResponse * __unused response,
                                                                 id responseObject,
                                                                 NSError *error) {
                                                 if (completion) {
                                                     if (!error) {
                                                         completion(responseObject, nil);
                                                     } else {
                                                         completion(responseObject, error);
                                                     }
                                                 }
                                             }];

    [dataTask resume];
    return dataTask; 
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                   completion:(void (^)(OVCResponse *, NSError *))completion {
    NSURLSessionDataTask *task = [self _dataTaskWithHTTPMethod:@"PUT"
                                                     URLString:URLString
                                                    parameters:parameters
                                                    completion:completion];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
                     completion:(void (^)(OVCResponse *, NSError *))completion {
    NSURLSessionDataTask *task = [self _dataTaskWithHTTPMethod:@"PATCH"
                                                     URLString:URLString
                                                    parameters:parameters
                                                    completion:completion];
    [task resume];
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                      completion:(void (^)(OVCResponse *, NSError *))completion {
    NSURLSessionDataTask *task = [self _dataTaskWithHTTPMethod:@"DELETE"
                                                     URLString:URLString
                                                    parameters:parameters
                                                    completion:completion];
    [task resume];
    return task;
}

@end
