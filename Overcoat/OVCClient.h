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

#import "AFHTTPClient.h"

@class OVCRequestOperation;

// Provides HTTP methods that return MTLModel subclasses.
@interface OVCClient : AFHTTPClient

// Creates an `OVCRequestOperation` with a `GET` request, and enqueues it to the HTTP client's operation queue.
//
// path        - The path to be appended to the HTTP client's base URL and used as the request URL.
// parameters  - The parameters to be encoded and appended as the query string for the request URL.
// resultClass - MTLModel subclass in which the response (or part of the response) will be transformed.
// keyPath     - Key path in the JSON response that contains the data to be transformed. If this is nil,
//               the whole response will be used.
// completion  - A block to be executed when the operation finishes. Depending on the response, the responseObject
//               parameter will contain either a single instance or an array of instances of `resultClass`.
- (OVCRequestOperation *)GET:(NSString *)path
                  parameters:(NSDictionary *)parameters
                 resultClass:(Class)resultClass
               resultKeyPath:(NSString *)keyPath
                  completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

// Creates an `OVCRequestOperation` with a `POST` request, and enqueues it to the HTTP client's operation queue.
//
// path        - The path to be appended to the HTTP client's base URL and used as the request URL.
// parameters  - The parameters to be encoded and appended as the query string for the request URL.
// resultClass - MTLModel subclass in which the response (or part of the response) will be transformed.
// keyPath     - Key path in the JSON response that contains the data to be transformed. If this is nil,
//               the whole response will be used.
// completion  - A block to be executed when the operation finishes. Depending on the response, the responseObject
//               parameter will contain either a single instance or an array of instances of `resultClass`.
- (OVCRequestOperation *)POST:(NSString *)path
                   parameters:(NSDictionary *)parameters
                  resultClass:(Class)resultClass
                resultKeyPath:(NSString *)keyPath
                   completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

// Creates an `OVCRequestOperation` with a `PUT` request, and enqueues it to the HTTP client's operation queue.
//
// path        - The path to be appended to the HTTP client's base URL and used as the request URL.
// parameters  - The parameters to be encoded and appended as the query string for the request URL.
// resultClass - MTLModel subclass in which the response (or part of the response) will be transformed.
// keyPath     - Key path in the JSON response that contains the data to be transformed. If this is nil,
//               the whole response will be used.
// completion  - A block to be executed when the operation finishes. Depending on the response, the responseObject
//               parameter will contain either a single instance or an array of instances of `resultClass`.
- (OVCRequestOperation *)PUT:(NSString *)path
                  parameters:(NSDictionary *)parameters
                 resultClass:(Class)resultClass
               resultKeyPath:(NSString *)keyPath
                  completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;


// Creates an `OVCRequestOperation` that loads the specified request and transforms the result into a model or an
// array of model objects.
//
// urlRequest  - The request object to be loaded asynchronously during execution of the operation.
// resultClass - MTLModel subclass in which the response (or part of the response) will be transformed.
// keyPath     - Key path in the JSON response that contains the data to be transformed. If this is nil,
//               the whole response will be used.
// completion  - A block to be executed when the operation finishes. Depending on the response, the responseObject
//               parameter will contain either a single instance or an array of instances of `resultClass`.
- (OVCRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                             resultClass:(Class)resultClass
                                           resultKeyPath:(NSString *)keyPath
                                              completion:(void (^)(AFHTTPRequestOperation *operation, id responseObject, NSError *error))block;

// Creates an `NSMutableURLRequest` object with the specified HTTP method and path, and constructs a `multipart/form-data`
// HTTP body using the specified parameters and array of parts.
// method     - The HTTP method for the request. This parameter must not be `GET` or `HEAD`, or `nil`.
// path       - The path to be appended to the HTTP client's base URL and used as the request URL.
// parameters - The parameters to be encoded and set in the request HTTP body.
// parts      - Array of OVCMultipartPart objects.
- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                                                  parts:(NSArray *)parts;

@end

@interface OVCClient (Unavailable)

- (AFHTTPRequestOperation *)executeQuery:(id)query completionBlock:(void (^)(AFHTTPRequestOperation *operation, id object, NSError *error))block __attribute__((deprecated("Replaced by -HTTPRequestOperationWithRequest:resultClass:resultKeyPath:completion:")));

- (NSMutableURLRequest *)requestWithQuery:(id)query __attribute__((deprecated("Replaced by -HTTPRequestOperationWithRequest:resultClass:resultKeyPath:completion:")));

@end