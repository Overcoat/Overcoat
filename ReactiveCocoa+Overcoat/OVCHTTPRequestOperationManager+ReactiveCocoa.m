//
//  OVCHTTPRequestOperationManager+ReactiveCocoa.m
//  Overcoat
//
//  Created by Joan Romano on 28/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "OVCHTTPRequestOperationManager+ReactiveCocoa.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation OVCHTTPRequestOperationManager (ReactiveCocoa)

- (RACSignal *)rac_GET:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self GET:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_HEAD:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self HEAD:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_POST:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self POST:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_POST:(NSString *)URLString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self POST:URLString parameters:parameters constructingBodyWithBlock:block completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, constructingBodyWithBlock", self.class, URLString, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self PUT:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self PATCH:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, URLString, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        __block AFHTTPRequestOperation *task = [self DELETE:URLString parameters:parameters completion:^(id response, NSError *error) {
            if (response) {
                [subscriber sendNext:response];
            } else if (error) {
                [subscriber sendError:error];
            }
            
            [subscriber sendCompleted];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, URLString, parameters];
}

@end
