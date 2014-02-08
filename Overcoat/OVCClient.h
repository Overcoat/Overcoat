// OVCClient.h
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

#import <AFNetworking/AFNetworking.h>
#import <Accounts/Accounts.h>

/**
 Provides HTTP methods that return MTLModel subclasses.
 */
@interface OVCClient : AFHTTPRequestOperationManager

/**
 Creates and initializes an `OVCClient` object with the specified base URL and account.
 
 @param url The base URL for the client. Can be nil.
 @param account The user account that will be used to authenticate requests.
 */
+ (instancetype)clientWithBaseURL:(NSURL *)url account:(ACAccount *)account;

/**
 Cancels all queued and running `AFHTTPRequestOperation` objects.
 */
- (void)cancelAllOperations;

/**
 Creates and runs an `AFHTTPRequestOperation` with a `GET` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param resultClass MTLModel subclass in which the response (or part of the response) will be transformed.
 @param keyPath Key path in the JSON response that contains the data to be transformed. If this is nil, the whole response will be used.
 @param completion A block to be executed when the operation finishes. Depending on the response, the responseObject parameter will contain either a single instance or an array of instances of `resultClass`.
 */
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                    resultClass:(Class)resultClass
                  resultKeyPath:(NSString *)keyPath
                     completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

/**
 Creates and runs an `AFHTTPRequestOperation` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param resultClass MTLModel subclass in which the response (or part of the response) will be transformed.
 @param keyPath Key path in the JSON response that contains the data to be transformed. If this is nil, the whole response will be used.
 @param completion A block to be executed when the operation finishes. Depending on the response, the responseObject parameter will contain either a single instance or an array of instances of `resultClass`.
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     resultClass:(Class)resultClass
                   resultKeyPath:(NSString *)keyPath
                      completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

/**
 Creates and runs an `AFHTTPRequestOperation` with a `POST` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param resultClass MTLModel subclass in which the response (or part of the response) will be transformed.
 @param keyPath Key path in the JSON response that contains the data to be transformed. If this is nil, the whole response will be used.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `AFMultipartFormData` protocol.
 @param completion A block to be executed when the operation finishes. Depending on the response, the responseObject parameter will contain either a single instance or an array of instances of `resultClass`.
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     resultClass:(Class)resultClass
                   resultKeyPath:(NSString *)keyPath
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

/**
 Creates and runs an `AFHTTPRequestOperation` with a `PUT` request.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param resultClass MTLModel subclass in which the response (or part of the response) will be transformed.
 @param keyPath Key path in the JSON response that contains the data to be transformed. If this is nil, the whole response will be used.
 @param completion A block to be executed when the operation finishes. Depending on the response, the responseObject parameter will contain either a single instance or an array of instances of `resultClass`.
 */
- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                    resultClass:(Class)resultClass
                  resultKeyPath:(NSString *)keyPath
                     completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

/**
 Creates an `AFHTTPRequestOperation` that loads the specified request and transforms the result into a model or an array of model objects.
 
 @param urlRequest The request object to be loaded asynchronously during execution of the operation.
 @param resultClass MTLModel subclass in which the response (or part of the response) will be transformed.
 @param keyPath Key path in the JSON response that contains the data to be transformed. If this is nil, the whole response will be used.
 @param completion A block to be executed when the operation finishes. Depending on the response, the responseObject parameter will contain either a single instance or an array of instances of `resultClass`.
 */
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                resultClass:(Class)resultClass
                                              resultKeyPath:(NSString *)keyPath
                                                 completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

@end
