// OVCModelResponseSerializer.h
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

#import <AFNetworking/AFURLResponseSerialization.h>
#import <Overcoat/OVCUtilities.h>

@class OVCURLMatcher;

NS_ASSUME_NONNULL_BEGIN

/**
 AFJSONResponseSerializer subclass that validates and transforms a JSON response into a
 `OVCResponse` object.
 */
@interface OVCModelResponseSerializer : AFHTTPResponseSerializer

/**
 Matches URLs in HTTP responses with model classes.
 */
@property (strong, nonatomic, readonly) OVCURLMatcher *modelClassURLMatcher;
/**
 Matches URLs in HTTP responses with response classes.
 */
@property (strong, nonatomic, readonly, OVC_NULLABLE) OVCURLMatcher *responseClassURLMatcher;

/**
 Matches URLs in HTTP responses with error model classes.
 */
@property (strong, nonatomic, readonly, OVC_NULLABLE) OVCURLMatcher *errorModelClassURLMatcher;

/**
 TODO: Doc for why don't inherite it (PR104)
 */
@property(nonatomic, strong) AFJSONResponseSerializer *jsonSerializer;

/**
 Creates and returns model serializer.
 */
+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)modelClassURLMatcher
                           responseClass:(OVC_NULLABLE Class)responseClass
                         errorModelClass:(OVC_NULLABLE Class)errorModelClass;

+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)modelClassURLMatcher
                 responseClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)responseClassURLMatcher
               errorModelClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)errorModelClassURLMatcher;

- (instancetype)initWithURLMatcher:(OVCURLMatcher *)modelClassURLMatcher
           responseClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)responseClassURLMatcher
         errorModelClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)errorModelClassURLMatcher NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - Deprecated

@interface OVCModelResponseSerializer (Deprecated)

@property (strong, nonatomic, readonly) OVCURLMatcher *URLMatcher OVC_DEPRECATED("Use `modelClassURLMatcher` property");

@end

NS_ASSUME_NONNULL_END
