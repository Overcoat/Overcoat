// OVCHTTPSessionManager+ReactiveCocoa.h
//
// Copyright (c) 2013-2016 Overcoat Team
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

#import <Overcoat/OVCHTTPSessionManager.h>
#import <Overcoat/OVCUtilities.h>

@class RACSignal;
@protocol RACSubscriber;

NS_ASSUME_NONNULL_BEGIN

@interface OVCHTTPSessionManager (ReactiveCocoa)

/**
 Enqueues a `GET` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param downloadProgress Subscribes `downloadProgress` to `next` events with `NSProgress` object,
 to be sent on each downloading object update and completes then, send error on downloading error.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_GET:(NSString *)URLString
            parameters:(OVC_NULLABLE id)parameters
              progress:(OVC_NULLABLE id<RACSubscriber>)downloadProgress;

/**
 Enqueues a `HEAD` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_HEAD:(NSString *)URLString parameters:(OVC_NULLABLE id)parameters;

/**
 Enqueues a `POST` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param uploadProgress Subscribes `uploadProgress` to `next` events with `NSProgress` object,
 to be sent on each uploading object update and completes then, send error on uploading error.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(OVC_NULLABLE id)parameters
               progress:(OVC_NULLABLE id<RACSubscriber>)uploadProgress;

/**
 Enqueues a multipart `POST` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block
 argument is an object adopting the `AFMultipartFormData` protocol.
 @param uploadProgress Subscribes `uploadProgress` to `next` events with `NSProgress` object,
 to be sent on each uploading object update and completes then, send error on uploading error.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(OVC_NULLABLE id)parameters
constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))block
               progress:(OVC_NULLABLE id<RACSubscriber>)uploadProgress;

/**
 Enqueues a `PUT` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_PUT:(NSString *)URLString parameters:(OVC_NULLABLE id)parameters;

/**
 Enqueues a `PATCH` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_PATCH:(NSString *)URLString parameters:(OVC_NULLABLE id)parameters;

/**
 Enqueues a `DELETE` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_DELETE:(NSString *)URLString parameters:(OVC_NULLABLE id)parameters;

@end

#pragma mark - Deprecated Methods

@interface OVCHTTPSessionManager (ReactiveCocoa_Deprecated)

/**
 Enqueues a `GET` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.

 @return A cold signal which sends a `NSProgress` object on each downloading object update
 and `OVCResponse` when downloading complete on next event and completes, or error otherwise
 */
- (RACSignal *)rac_GET:(NSString *)URLString parameters:(OVC_NULLABLE id)parameters OVC_DEPRECATED("Use `rac_GET:parameters:progress:` instead.");

/**
 Enqueues a `POST` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.

 @return A cold signal which sends a `NSProgress` object on each uploading object update
 and `OVCResponse` when uploading complete on next event and completes, or error otherwise
 */
- (RACSignal *)rac_POST:(NSString *)URLString parameters:(OVC_NULLABLE id)parameters OVC_DEPRECATED("Use `rac_POST:parameters:progress:` instead.");

/**
 Enqueues a multipart `POST` request.

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param block A block that takes a single argument and appends data to the HTTP body. The block
 argument is an object adopting the `AFMultipartFormData` protocol.

 @return A cold signal which sends a `OVCResponse` on next event and completes, or error otherwise
 */
- (RACSignal *)rac_POST:(NSString *)URLString
             parameters:(OVC_NULLABLE id)parameters
constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))block OVC_DEPRECATED("Use `rac_POST:parameters:constructingBodyWithBlock:progress:` instead.");

@end

NS_ASSUME_NONNULL_END
