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

@class NSManagedObjectContext;

/**
 `OVCHTTPRequestOperationManager` provides methods to communicate with a web application over HTTP,
 mapping responses into native model objects which can optionally be persisted in a Core Data store.
 */
@interface OVCHTTPRequestOperationManager : AFHTTPRequestOperationManager

/**
 The managed object context that will be used to persist model objects parsed from a response.
 */
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

/**
 Returns the class used to create responses.
 
 This method returns the `OVCResponse` class object by default. Subclasses can override this method
 and return a different `OVCResponse` subclass as needed.
 
 @return The class that used to create responses.
 */
+ (Class)responseClass;

/**
 Specifies a model class for server error responses.
 
 This method returns `Nil` by default. Subclasses can override this method and return an `MTLModel`
 subclass that will be used to parse the JSON in an error response.
 */
+ (Class)errorModelClass;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcomment"
/**
 Specifies how to map responses to different model classes.
 
 Subclasses must override this method and return a dictionary mapping resource paths to model
 classes. Consider the following example for a GitHub client:
 
    + (NSDictionary *)modelClassesByResourcePath {
        return @{
            @"/users/*": [GTHUser class],
            @"/orgs/*": [GTHOrganization class]
        }
    }
 
 Note that you can use `*` to match any text or `#` to match only digits.
 
 @return A dictionary mapping resource paths to model classes.
 */
#pragma clang diagnostic pop
+ (NSDictionary *)modelClassesByResourcePath;

/**
 Initializes the receiver with the specified base URL and managed object context.
 
 This is the designated initializer.
 
 @param url The base URL for the HTTP client.
 @param context An optional managed object context that will be used to persist model objects
                parsed from a response. If the context concurrency type is not
                `NSPrivateQueueConcurrencyType`, a private context will be used to perform
                insertions in the background.
 
 @return An initialized client.
 */
- (id)initWithBaseURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context;

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
                     parameters:(NSDictionary *)parameters
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
                      parameters:(NSDictionary *)parameters
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
                      parameters:(NSDictionary *)parameters
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
                     parameters:(NSDictionary *)parameters
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
                       parameters:(NSDictionary *)parameters
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
                        parameters:(NSDictionary *)parameters
                        completion:(void (^)(id response, NSError *error))completion;

@end
