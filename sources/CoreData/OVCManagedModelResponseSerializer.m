// OVCManagedModelResponseSerializer.m
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

#import "OVCManagedModelResponseSerializer_Internal.h"
#import "OVCResponse.h"
#import <CoreData/CoreData.h>
#import <MTLManagedObjectAdapter/MTLManagedObjectAdapter.h>
#import "OVCManagedObjectSerializingContainer.h"

@interface OVCManagedModelResponseSerializer ()

@end

@implementation OVCManagedModelResponseSerializer

+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)URLMatcher
                 responseClassURLMatcher:(OVCURLMatcher *)URLResponseClassMatcher
                    managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                           responseClass:(Class)responseClass
                         errorModelClass:(Class)errorModelClass {
    OVCManagedModelResponseSerializer *serializer = [self serializerWithURLMatcher:URLMatcher
                                                           responseClassURLMatcher:URLResponseClassMatcher
                                                                     responseClass:responseClass
                                                                   errorModelClass:errorModelClass];
    serializer.managedObjectContext = managedObjectContext;
    return serializer;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error {
    OVCResponse *responseObject = [super responseObjectForResponse:response data:data error:error];
    Class resultClass = responseObject.resultClass;
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
    return responseObject;
}

#pragma mark - Private

- (void)saveResult:(id)result {
    NSParameterAssert(result);
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    [context performBlockAndWait:^{
        NSArray *models = [result isKindOfClass:[NSArray class]] ? result : @[result];

        for (MTLModel<MTLManagedObjectSerializing> *model in models) {
            NSError *error = nil;
            [MTLManagedObjectAdapter managedObjectFromModel:model
                                       insertingIntoContext:context
                                                      error:&error];
            NSAssert(error == nil, @"%@ saveResult failed with error: %@", self, error);
        }

        if (context.hasChanges) {
            NSError *error = nil;
            [context save:&error];
            NSAssert(error == nil, @"%@ saveResult failed with error: %@", self, error);
        }
    }];
}

@end
