// OVCHTTPRequestOperationManager.h
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

#import <AFNetworking/AFNetworking.h>
#import <Overcoat/OVCHTTPManager.h>

/**
 `OVCHTTPRequestOperationManager` provides methods to communicate with a web application over HTTP,
 mapping responses into native model objects via Mantle
 */
@interface OVCHTTPRequestOperationManager : AFHTTPRequestOperationManager <OVCHTTPManager>

/**
 Cancels all outstanding requests.
 */
- (void)cancelAllRequests;

///---------------------------
/// @name Making HTTP Requests
///---------------------------

/**
 Enqueues a `GET` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                     completion:(void (^)(id response, NSError *error))completion;

/**
 Enqueues a `HEAD` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(id)parameters
                      completion:(void (^)(id response, NSError *error))completion;

/**
 Enqueues a `POST` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                      completion:(void (^)(id response, NSError *error))completion;

/**
 Enqueues a multipart `POST` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block
              argument is an object adopting the `AFMultipartFormData` protocol.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
       constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      completion:(void (^)(id response, NSError *error))completion;

/**
 Enqueues a `PUT` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)PUT:(NSString *)URLString
                     parameters:(id)parameters
                     completion:(void (^)(id response, NSError *error))completion;

/**
 Enqueues a `PATCH` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)PATCH:(NSString *)URLString
                       parameters:(id)parameters
                       completion:(void (^)(id response, NSError *error))completion;

/**
 Enqueues a `DELETE` request and executes a block when the request completes or fails.

 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (AFHTTPRequestOperation *)DELETE:(NSString *)URLString
                        parameters:(id)parameters
                        completion:(void (^)(id response, NSError *error))completion;

@end
