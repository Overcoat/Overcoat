// OVCHTTPRequestOperationManager+PromiseKit.m
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

#import "OVCHTTPRequestOperationManager+PromiseKit.h"

#import <PromiseKit/PromiseKit.h>

@implementation OVCHTTPRequestOperationManager (PromiseKit)

- (Promise *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self GET:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

- (Promise *)HEAD:(NSString *)URLString parameters:(id)parameters {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self HEAD:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

- (Promise *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self POST:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

- (Promise *)POST:(NSString *)URLString
       parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block
{
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self POST:URLString parameters:parameters constructingBodyWithBlock:block completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

- (Promise *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self PUT:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

- (Promise *)PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self PATCH:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

- (Promise *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters {
    return [Promise new:^(PromiseFulfiller fulfiller, PromiseRejecter rejecter) {
        [self DELETE:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (error) {
                rejecter(error);
            } else {
                fulfiller(response);
            }
        }];
    }];
}

@end
