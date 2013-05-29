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

static NSString *HTTPMethod(OVCQueryMethod method) {
    static dispatch_once_t onceToken;
    static NSDictionary *methods;

    dispatch_once(&onceToken, ^{
        methods = @{
                @(OVCQueryMethodGet) : @"GET",
                @(OVCQueryMethodPost) : @"POST",
                @(OVCQueryMethodPut) : @"PUT",
                @(OVCQueryMethodDelete) : @"DELETE"
        };
    });

    return methods[@(method)];
}

@implementation OVCClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[OVCRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }

    return self;
}

- (OVCRequestOperation *)executeQuery:(OVCQuery *)query completionBlock:(void (^)(OVCRequestOperation *, id, NSError *))block {
    NSParameterAssert(query);

    OVCRequestOperation *requestOperation = (OVCRequestOperation *)[self HTTPRequestOperationWithRequest:[self requestWithQuery:query] success:nil failure:nil];
    NSAssert([requestOperation isKindOfClass:[OVCRequestOperation class]], @"*** Unsupported operation class.");
    
    requestOperation.transformBlock = query.transformBlock;
    
    if (block) {
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            block((OVCRequestOperation *) operation, responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block((OVCRequestOperation *) operation, nil, error);
        }];
    }

    [self enqueueHTTPRequestOperation:requestOperation];

    return requestOperation;
}

- (NSMutableURLRequest *)requestWithQuery:(OVCQuery *)query {
    NSParameterAssert(query);

    if ([query.parts count]) {
        return [self multipartFormRequestWithMethod:HTTPMethod(query.method) path:query.path parameters:query.parameters constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
            for (OVCMultipartPart *part in query.parts) {
                [formData appendPartWithFileData:part.data name:part.name fileName:part.filename mimeType:part.type];
            }
        }];
    }
    else {
        return [self requestWithMethod:HTTPMethod(query.method) path:query.path parameters:query.parameters];
    }
}

@end
