// OVCURLMatcher.h
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

#import <Foundation/Foundation.h>
#import <Overcoat/OVCUtilities.h>

NS_ASSUME_NONNULL_BEGIN

@class OVCURLMatcherNode;

/**
 Helper class to aid in matching URLs to model classes.
 
 The source code of this class is based on `SCLURLModelMatcher` from
 https://github.com/dcaunt/Sculptor/ by David Caunt.
 */
@interface OVCURLMatcher : NSObject

+ (instancetype)matcherWithBasePath:(OVC_NULLABLE NSString *)basePath
                 modelClassesByPath:(OVC_NULLABLE NSDictionary OVCGenerics(NSString *, id) *)modelClassesByPath;
- (instancetype)initWithBasePath:(OVC_NULLABLE NSString *)basePath
              modelClassesByPath:(OVC_NULLABLE NSDictionary OVCGenerics(NSString *, id) *)modelClassesByPath;

+ (instancetype)matcherWithBasePath:(OVC_NULLABLE NSString *)basePath
                 matcherNodesByPath:(OVC_NULLABLE NSDictionary OVCGenerics(NSString *, OVCURLMatcherNode *) *)nodes;
- (instancetype)initWithBasePath:(OVC_NULLABLE NSString *)basePath
              matcherNodesByPath:(OVC_NULLABLE NSDictionary OVCGenerics(NSString *, OVCURLMatcherNode *) *)matcherNodes
NS_DESIGNATED_INITIALIZER;

- (OVC_NULLABLE Class)modelClassForURL:(NSURL *)url;
- (OVC_NULLABLE Class)modelClassForURLRequest:(OVC_NULLABLE NSURLRequest *)request
                               andURLResponse:(OVC_NULLABLE NSHTTPURLResponse *)urlResponse;

- (void)addModelClass:(Class)modelClass forPath:(NSString *)path;
- (void)addMatcherNode:(OVCURLMatcherNode *)matcherNode forPath:(NSString *)path;

@end

typedef Class OVC__NULLABLE(^OVCURLMatcherNodeBlock)(NSURLRequest *OVC__NULLABLE, NSHTTPURLResponse *OVC__NULLABLE);

@interface OVCURLMatcherNode : NSObject

+ (instancetype)matcherNodeWithModelClass:(Class)ModelClass;
+ (instancetype)matcherNodeWithResponseCode:(NSDictionary OVCGenerics(NSNumber *, Class) *)modelClasses;
+ (instancetype)matcherNodeWithRequestMethod:(NSDictionary OVCGenerics(NSString *, Class) *)modelClasses;
+ (instancetype)matcherNodeWithModelClasses:(NSDictionary OVCGenerics(id, Class) *)modelClasses;
+ (instancetype)matcherNodeWithBlock:(OVCURLMatcherNodeBlock)block;
- (instancetype)initWithBlock:(OVCURLMatcherNodeBlock)block NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (OVC_NULLABLE Class)modelClassForURLRequest:(OVC_NULLABLE NSURLRequest *)request
                               andURLResponse:(OVC_NULLABLE NSHTTPURLResponse *)urlResponse;

@end

NS_ASSUME_NONNULL_END
