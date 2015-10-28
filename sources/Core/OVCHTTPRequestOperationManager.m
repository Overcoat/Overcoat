// OVCHTTPRequestOperationManager.m
// 
// Copyright (c) 2014 Guillermo Gonzalez
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

#import "OVCHTTPRequestOperationManager.h"
#import "OVCResponse.h"
#import "OVCModelResponseSerializer.h"
#import "OVCURLMatcher.h"
#import "OVCHTTPManager_Internal.h"
#import "NSError+OVCResponse.h"

@implementation OVCHTTPRequestOperationManager

#pragma mark - Object Methods

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = OVCHTTPManagerCreateModelResponseSerializer(self);
    }
    return self;
}

- (void)cancelAllRequests {
    [self.operationQueue cancelAllOperations];
}

#pragma mark - HTTP Manager Protocol

+ (Class)responseClass {
    return [OVCResponse class];
}

+ (Class)errorModelClass {
    return nil;
}

+ (NSDictionary *)modelClassesByResourcePath {
    [NSException
     raise:NSInvalidArgumentException
     format:@"+[%@ %@] should be overridden by subclass", NSStringFromClass(self), NSStringFromSelector(_cmd)];
    return nil;  // Not reached
}

+ (NSDictionary *)responseClassesByResourcePath {
    return nil;
}

#pragma mark - Making requests

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                     completion:(void (^)(OVCResponse *response, NSError *error))completion {
    return [self GET:URLString parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (completion) {
                     completion(responseObject, nil);
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) {
                     error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                     completion(operation.responseObject, error);
                 }
             }];
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(id)parameters
                      completion:(void (^)(OVCResponse *, NSError *))completion {
    return [self HEAD:URLString parameters:parameters
              success:^(AFHTTPRequestOperation *operation) {
                  if (completion) {
                      completion(operation.responseObject, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) {
                      error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                      completion(operation.responseObject, error);
                  }
              }];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                      completion:(void (^)(OVCResponse *, NSError *))completion {
    return [self POST:URLString parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completion) {
                      completion(responseObject, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) {
                      error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                      completion(operation.responseObject, error);
                  }
              }];
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
                      completion:(void (^)(OVCResponse *, NSError *))completion {
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  if (completion) {
                      completion(responseObject, nil);
                  }
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (completion) {
                      error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                      completion(operation.responseObject, error);
                  }
              }];
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
                     completion:(void (^)(OVCResponse *, NSError *))completion {
    return [self PUT:URLString parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 if (completion) {
                     completion(responseObject, nil);
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) {
                     error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                     completion(operation.responseObject, error);
                 }
             }];
}

- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(id)parameters
                       completion:(void (^)(OVCResponse *, NSError *))completion {
    return [self PATCH:URLString parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   if (completion) {
                       error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                       completion(operation.responseObject, error);
                   }
               }];
}

- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                        completion:(void (^)(OVCResponse *, NSError *))completion {
    return [self DELETE:URLString parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if (completion) {
                        completion(responseObject, nil);
                    }
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (completion) {
                        error = [error ovc_errorWithUnderlyingResponse:operation.responseObject];
                        completion(operation.responseObject, error);
                    }
                }];
}

@end
