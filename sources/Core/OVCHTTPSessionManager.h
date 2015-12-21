// OVCHTTPSessionManager.h
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

#import <AFNetworking/AFHTTPSessionManager.h>
#import <Overcoat/OVCUtilities.h>

@class OVCResponse;

NS_ASSUME_NONNULL_BEGIN

/**
 `OVCHTTPSessionManager` provides methods to communicate with a web application over HTTP, mapping
 responses into native model objects which can optionally be persisted in a Core Data store.
 */
@interface OVCHTTPSessionManager OVCGenerics(ResponseType: OVCResponse *) : AFHTTPSessionManager

/**
 Specifies how to map responses to different model classes.

 Subclasses must override this method and return a dictionary mapping resource paths to model
 classes.
 Note that you can use `*` and `**` to match any text or `#` to match only digits.

 @see https://github.com/Overcoat/Overcoat#specifying-model-classes

 @return A dictionary mapping resource paths to model classes.
 */
+ (NSDictionary OVCGenerics(NSString *, id) *)modelClassesByResourcePath;

/**
 Specifies how to map responses to different response classes.

 Subclasses can override this method and return a dictionary mapping resource paths to response
 classes. Consider the following example for a GitHub client:

 + (NSDictionary *)responseClassesByResourcePath {
 return @{
 @"/users": [GTHUserResponse class],
 @"/orgs": [GTHOrganizationResponse class]
 };
 }

 Note that you can use `*` to match any text or `#` to match only digits.
 If a subclass override this method, the responseClass method will be ignored

 @return A dictionary mapping resource paths to response classes.
 */
+ (OVC_NULLABLE NSDictionary OVCGenerics(NSString *, id) *)responseClassesByResourcePath;

+ (OVC_NULLABLE NSDictionary OVCGenerics(NSString *, id) *)errorModelClassesByResourcePath;

///---------------------------
/// @name Making HTTP Requests
///---------------------------

/**
 Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)GET:(NSString *)URLString
                                parameters:(OVC_NULLABLE id)parameters
                                completion:(OVC_NULLABLE void(^)
                                            (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                             NSError * OVC__NULLABLE error))completion;

/**
 Creates and runs an `NSURLSessionDataTask` with a `GET` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)HEAD:(NSString *)URLString
                                 parameters:(OVC_NULLABLE id)parameters
                                 completion:(OVC_NULLABLE void(^)
                                             (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                              NSError * OVC__NULLABLE error))completion;

/**
 Creates and runs an `NSURLSessionDataTask` with a `POST` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)POST:(NSString *)URLString
                                 parameters:(OVC_NULLABLE id)parameters
                                 completion:(OVC_NULLABLE void(^)
                                             (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                              NSError * OVC__NULLABLE error))completion;

/**
 Creates and runs an `NSURLSessionDataTask` with a multipart `POST` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block
 argument is an object adopting the `AFMultipartFormData` protocol.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)POST:(NSString *)URLString
                                 parameters:(OVC_NULLABLE id)parameters
                  constructingBodyWithBlock:(OVC_NULLABLE void(^)(id<AFMultipartFormData> formData))block
                                 completion:(OVC_NULLABLE void(^)
                                             (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                              NSError * OVC__NULLABLE error))completion;

/**
 Creates and runs an `NSURLSessionDataTask` with a `PUT` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)PUT:(NSString *)URLString
                                parameters:(OVC_NULLABLE id)parameters
                                completion:(OVC_NULLABLE void(^)
                                            (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                             NSError * OVC__NULLABLE error))completion;

/**
 Creates and runs an `NSURLSessionDataTask` with a `PATCH` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)PATCH:(NSString *)URLString
                                  parameters:(OVC_NULLABLE id)parameters
                                  completion:(OVC_NULLABLE void(^)
                                              (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                               NSError * OVC__NULLABLE error))completion;

/**
 Creates and runs an `NSURLSessionDataTask` with a `DELETE` request.
 
 If the request completes successfully, the `response` parameter of the completion block contains a
 `OVCResponse` object, and the `error` parameter is `nil`. If the request fails, the error parameter
 contains information about the failure.
 
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param completion A block to be executed when the request finishes.
 */
- (OVC_NULLABLE NSURLSessionDataTask *)DELETE:(NSString *)URLString
                                   parameters:(OVC_NULLABLE id)parameters
                                   completion:(OVC_NULLABLE void(^)
                                               (OVCGenericType(ResponseType, OVCResponse *) OVC__NULLABLE response,
                                                NSError * OVC__NULLABLE error))completion;

@end

@interface OVCHTTPSessionManager (Deprecated)

+ (Class)responseClass OVC_DEPRECATED("Use `responseClassesByResourcePath` instead.");
+ (OVC_NULLABLE Class)errorModelClass OVC_DEPRECATED("Use `errorModelClassesByResourcePath` instead.");

@end

NS_ASSUME_NONNULL_END
