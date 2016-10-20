// OVCHTTPSessionManager+ReactiveCocoa.m
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

#import "OVCHTTPSessionManager+ReactiveCocoa.h"
#import <ReactiveObjC/RACSignal.h>
#import <ReactiveObjC/RACSubscriber.h>
#import <ReactiveObjC/RACDisposable.h>

@implementation OVCHTTPSessionManager (ReactiveCocoa)

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self GET:URLString
                                            parameters:parameters
                                              progress:nil
                                            completion:^(id response, NSError *error) {
                                                if (!error) {
                                                    [subscriber sendNext:response];
                                                    [subscriber sendCompleted];
                                                } else {
                                                    [subscriber sendError:error];
                                                }
                                            }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self HEAD:URLString
                                             parameters:parameters
                                             completion:^(id response, NSError *error) {
                                                 if (!error) {
                                                     [subscriber sendNext:response];
                                                     [subscriber sendCompleted];
                                                 } else {
                                                     [subscriber sendError:error];
                                                 }
                                             }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_POST:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self POST:URLString
                                             parameters:parameters
                                               progress:nil
                                             completion:^(id response, NSError *error) {
                                                 if (!error) {
                                                     [subscriber sendNext:response];
                                                     [subscriber sendCompleted];
                                                 } else {
                                                     [subscriber sendError:error];
                                                 }
                                             }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self POST:URLString
                                             parameters:parameters
                              constructingBodyWithBlock:block
                                               progress:nil
                                             completion:^(id response, NSError *error) {
                                                 if (!error) {
                                                     [subscriber sendNext:response];
                                                     [subscriber sendCompleted];
                                                 } else {
                                                     [subscriber sendError:error];
                                                 }
                                             }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, constructingBodyWithBlock",
            self.class, URLString, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self PUT:URLString
                                            parameters:parameters
                                            completion:^(id response, NSError *error) {
                                                if (!error) {
                                                    [subscriber sendNext:response];
                                                    [subscriber sendCompleted];
                                                } else {
                                                    [subscriber sendError:error];
                                                }
                                            }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self PATCH:URLString
                                              parameters:parameters
                                              completion:^(id response, NSError *error) {
                                                  if (!error) {
                                                      [subscriber sendNext:response];
                                                      [subscriber sendCompleted];
                                                  } else {
                                                      [subscriber sendError:error];
                                                  }
                                              }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self DELETE:URLString
                                               parameters:parameters
                                               completion:^(id response, NSError *error) {
                                                   if (!error) {
                                                       [subscriber sendNext:response];
                                                       [subscriber sendCompleted];
                                                   } else {
                                                       [subscriber sendError:error];
                                                   }
                                               }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, URLString, parameters];
}

#pragma mark -

- (RACSignal *)rac_GET:(NSString *)URLString
            parameters:(NSDictionary *)parameters
              progress:(id<RACSubscriber>)progress {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self GET:URLString
                                            parameters:parameters
                                              progress:^(NSProgress *downloadProgress) {
                                                  [progress sendNext:downloadProgress];
                                              }
                                            completion:^(id response, NSError *error) {
                                                if (!error) {
                                                    [subscriber sendNext:response];
                                                    [subscriber sendCompleted];
                                                    [progress sendCompleted];
                                                } else {
                                                    [subscriber sendError:error];
                                                    [progress sendError:error];
                                                }
                                            }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@, progress: %@",
            self.class, URLString, parameters, progress];
}


- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(NSDictionary *)parameters
               progress:(id<RACSubscriber>)progress {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self POST:URLString
                                             parameters:parameters
                                               progress:^(NSProgress *uploadProgress) {
                                                   [progress sendNext:uploadProgress];
                                               }
                                             completion:^(id response, NSError *error) {
                                                 if (!error) {
                                                     [subscriber sendNext:response];
                                                     [subscriber sendCompleted];
                                                     [progress sendCompleted];
                                                 } else {
                                                     [subscriber sendError:error];
                                                     [progress sendError:error];
                                                 }
                                             }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, progress: %@",
            self.class, URLString, parameters, progress];
}

- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
               progress:(id<RACSubscriber>)progress {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block NSURLSessionDataTask *task = [self POST:URLString
                                             parameters:parameters
                              constructingBodyWithBlock:block
                                               progress:^(NSProgress *uploadProgress) {
                                                   [progress sendNext:uploadProgress];
                                               }
                                             completion:^(id response, NSError *error) {
                                                 if (!error) {
                                                     [subscriber sendNext:response];
                                                     [subscriber sendCompleted];
                                                     [progress sendCompleted];
                                                 } else {
                                                     [subscriber sendError:error];
                                                     [progress sendError:error];
                                                 }
                                             }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, constructingBodyWithBlock %@, progress %@",
            self.class, URLString, parameters, block, progress];
}

@end
