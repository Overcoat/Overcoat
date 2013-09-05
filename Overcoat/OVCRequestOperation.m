// OVCRequestOperation.m
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

#import "OVCRequestOperation.h"
#import "EXTScope.h"
#import "NSDictionary+Overcoat.h"

#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#import <Mantle/MTLValueTransformer.h>

static dispatch_queue_t OVCRequestOperationProcessingQueue() {
    static dispatch_once_t onceToken;
    static dispatch_queue_t processingQueue;

    dispatch_once(&onceToken, ^{
        processingQueue = dispatch_queue_create("com.gonzalezreal.overcoat.request.processing", DISPATCH_QUEUE_CONCURRENT);
    });

    return processingQueue;
}

@interface OVCRequestOperation ()

@property (strong, nonatomic, readwrite) id responseObject;
@property (strong, nonatomic) NSRecursiveLock *lock;

@end

@implementation OVCRequestOperation

@dynamic lock;

- (id)responseObject {
    [self.lock lock];
    if (!_responseObject) {
        id responseJSON = self.responseJSON;

        if (responseJSON) {
            if (self.valueTransformer) {
                self.responseObject = [self.valueTransformer transformedValue:responseJSON];
            }
            else {
                self.responseObject = self.responseJSON;
            }
        }
    }
    [self.lock unlock];

    return _responseObject;
}

+ (NSValueTransformer *)valueTransformerWithResultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath {
    NSParameterAssert(resultClass);

    return [MTLValueTransformer transformerWithBlock:^id(id response) {
        NSValueTransformer *JSONTransformer = nil;
        id object = response;

        if ([keyPath length] && [object isKindOfClass:[NSDictionary class]]) {
            object = [object ovc_objectForKeyPath:keyPath];
        }

        if ([object isKindOfClass:[NSDictionary class]]) {
            JSONTransformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:resultClass];
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            JSONTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:resultClass];
        }

        return [JSONTransformer transformedValue:object];
    }];
}

- (id)initWithRequest:(NSURLRequest *)urlRequest resultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath {
    self = [super initWithRequest:urlRequest];

    if (self) {
        _valueTransformer = [self.class valueTransformerWithResultClass:resultClass resultKeyPath:keyPath];
    }

    return self;
}

- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    @weakify(self);

    [self setCompletionBlock:^{
        @strongify(self);

        if (self.error) {
            if (failure) {
                dispatch_async(self.failureCallbackQueue ? : dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        }
        else {
            dispatch_async(OVCRequestOperationProcessingQueue(), ^{
                id responseObject = self.responseObject;

                if (self.error) {
                    if (failure) {
                        dispatch_async(self.failureCallbackQueue ? : dispatch_get_main_queue(), ^{
                            failure(self, self.error);
                        });
                    }
                }
                else {
                    if (success) {
                        dispatch_async(self.successCallbackQueue ? : dispatch_get_main_queue(), ^{
                            success(self, responseObject);
                        });
                    }
                }
            });
        }
    }];
}

@end
