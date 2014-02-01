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
#import "OVCModelResponseSerializer.h"
#import "OVCSocialRequestSerializer.h"

@implementation OVCClient

+ (instancetype)clientWithBaseURL:(NSURL *)url account:(ACAccount *)account {
    OVCClient *client = [[self alloc] initWithBaseURL:url];
    
    if (account) {
        client.requestSerializer = [OVCSocialRequestSerializer serializerWithAccount:account];
    }
    
    return client;
}

- (void)cancelAllOperations {
    [self.operationQueue cancelAllOperations];
}

- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                    resultClass:(Class)resultClass
                  resultKeyPath:(NSString *)keyPath
                     completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET"
                                                                   URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
                                                                  parameters:parameters
                                                                       error:NULL];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                  resultClass:resultClass
                                                                resultKeyPath:keyPath
                                                                   completion:block];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     resultClass:(Class)resultClass
                   resultKeyPath:(NSString *)keyPath
                      completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST"
                                                                   URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
                                                                  parameters:parameters
                                                                       error:NULL];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                  resultClass:resultClass
                                                                resultKeyPath:keyPath
                                                                   completion:block];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     resultClass:(Class)resultClass
                   resultKeyPath:(NSString *)keyPath
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))bodyBlock
                      completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block
{
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
                                                                               parameters:parameters
                                                                constructingBodyWithBlock:bodyBlock
                                                                                    error:NULL];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                  resultClass:resultClass
                                                                resultKeyPath:keyPath
                                                                   completion:block];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                    resultClass:(Class)resultClass
                  resultKeyPath:(NSString *)keyPath
                     completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"PUT"
                                                                   URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString]
                                                                  parameters:parameters
                                                                       error:NULL];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request
                                                                  resultClass:resultClass
                                                                resultKeyPath:keyPath
                                                                   completion:block];
    [self.operationQueue addOperation:operation];
    
    return operation;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                resultClass:(Class)resultClass
                                              resultKeyPath:(NSString *)keyPath
                                                 completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block
{
    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:urlRequest success:nil failure:nil];
    requestOperation.responseSerializer = [OVCModelResponseSerializer serializerWithModelClass:resultClass
                                                                               responseKeyPath:keyPath];
    
    if (block) {
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(operation, responseObject, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            block(operation, nil, error);
        }];
    }

    return requestOperation;
}

@end
