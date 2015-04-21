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
#import "OVCResponse.h"
#import "OVCURLMatcher.h"
#import "OVCManagedObjectSerializingContainer.h"

#import "NSError+OVCResponse.h"

#import <CoreData/CoreData.h>
#import <Mantle/Mantle.h>

@interface OVCModelResponseSerializer ()

@property (strong, nonatomic) OVCURLMatcher *URLMatcher;
@property (strong, nonatomic) OVCURLMatcher *URLResponseClassMatcher;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) Class responseClass;
@property (nonatomic) Class errorModelClass;

@end

@implementation OVCModelResponseSerializer

+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)URLMatcher
                 responseClassURLMatcher:(OVCURLMatcher *)URLResponseClassMatcher
                    managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                           responseClass:(Class)responseClass
                         errorModelClass:(Class)errorModelClass
{
    NSParameterAssert([responseClass isSubclassOfClass:[OVCResponse class]]);
    
    if (errorModelClass != Nil) {
        NSParameterAssert([errorModelClass isSubclassOfClass:[MTLModel class]]);
    }
    
    OVCModelResponseSerializer *serializer = [self serializerWithReadingOptions:0];
    serializer.URLMatcher = URLMatcher;
    serializer.URLResponseClassMatcher = URLResponseClassMatcher;
    serializer.managedObjectContext = managedObjectContext;
    serializer.responseClass = responseClass;
    serializer.errorModelClass = errorModelClass;
    
    return serializer;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSError *serializationError = nil;
    id JSONObject = [super responseObjectForResponse:response data:data error:&serializationError];
    
    if (error) {
        *error = serializationError;
    }
    
    if (serializationError && [serializationError code] != NSURLErrorBadServerResponse) {
        return nil;
    }
    
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    Class resultClass = Nil;
    Class responseClass = Nil;
    
    if (!serializationError) {
        resultClass = [self.URLMatcher modelClassForURL:HTTPResponse.URL];
        
        if (self.URLResponseClassMatcher) {
            responseClass = [self.URLResponseClassMatcher modelClassForURL:HTTPResponse.URL];
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
                                                              resultClass:resultClass];
    
    if (self.managedObjectContext) {
        id result = nil;
        
        if ([resultClass conformsToProtocol:@protocol(MTLManagedObjectSerializing)]) {
            result = responseObject.result;
        } else if ([resultClass conformsToProtocol:@protocol(OVCManagedObjectSerializingContainer)]) {
            NSString *keyPath = [resultClass managedObjectSerializingKeyPath];
            result = [responseObject.result valueForKeyPath:keyPath];
        }
        
        if (result) {
            [self saveResult:result];
        }
    }
        
    if (serializationError && error) {
        *error = [serializationError ovc_errorWithUnderlyingResponse:responseObject];
    }
    
    return responseObject;
}

#pragma mark - Private

- (void)saveResult:(id)result {
    NSParameterAssert(result);
    
    NSArray *models = [result isKindOfClass:[NSArray class]] ? result : @[result];
    for (MTLModel<MTLManagedObjectSerializing> *model in models) {
        NSError *error = nil;
        [MTLManagedObjectAdapter managedObjectFromModel:model
                                   insertingIntoContext:self.managedObjectContext
                                                  error:&error];
        NSAssert(error == nil, @"%@ saveResult failed with error: %@", self, error);
    }
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    [context performBlockAndWait:^{
        if ([context hasChanges]) {
            NSError *error = nil;
            [context save:&error];
            NSAssert(error == nil, @"%@ saveResult failed with error: %@", self, error);
        }
    }];
}

@end
