// OVCClient.m
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

#import "OVCClient.h"
#import "OVCRequestOperation.h"
#import "OVCMultipartPart.h"

@implementation OVCClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[OVCRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }

    return self;
}

- (AFHTTPRequestOperation *)GET:(NSString *)path parameters:(NSDictionary *)parameters resultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block {
    NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
    OVCRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                               resultClass:resultClass
                                                             resultKeyPath:keyPath
                                                                completion:block];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)path parameters:(NSDictionary *)parameters resultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block {
    NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    OVCRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                               resultClass:resultClass
                                                             resultKeyPath:keyPath
                                                                completion:block];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)path parameters:(NSDictionary *)parameters resultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block {
    NSURLRequest *request = [self requestWithMethod:@"PUT" path:path parameters:parameters];
    OVCRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                               resultClass:resultClass
                                                             resultKeyPath:keyPath
                                                                completion:block];
    [self enqueueHTTPRequestOperation:operation];
    return operation;
}

- (OVCRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest resultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block {
    OVCRequestOperation *requestOperation = (OVCRequestOperation *)[self HTTPRequestOperationWithRequest:urlRequest
                                                                                                 success:nil
                                                                                                 failure:nil];
    NSAssert([requestOperation isKindOfClass:[OVCRequestOperation class]], @"*** Unsupported operation class.");

    requestOperation.valueTransformer = [OVCRequestOperation valueTransformerWithResultClass:resultClass resultKeyPath:keyPath];

    if (block) {
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((OVCRequestOperation *) operation, responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((OVCRequestOperation *) operation, nil, error);
        }];
    }

    return requestOperation;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters parts:(NSArray *)parts {
    return [self multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        for (OVCMultipartPart *part in parts) {
            [formData appendPartWithFileData:part.data name:part.name fileName:part.filename mimeType:part.type];
        }
    }];
}

@end
