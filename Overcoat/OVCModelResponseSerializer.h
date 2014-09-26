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

#import <AFNetworking/AFNetworking.h>

@class OVCURLMatcher;
@class NSManagedObjectContext;

/**
 AFJSONResponseSerializer subclass that validates and transforms a JSON response into a
 `OVCResponse` object.
 */
@interface OVCModelResponseSerializer : AFJSONResponseSerializer

/**
 Matches URLs in HTTP responses with model classes.
 */
@property (strong, nonatomic, readonly) OVCURLMatcher *URLMatcher;
/**
 Matches URLs in HTTP responses with response classes.
 */
@property (strong, nonatomic, readonly) OVCURLMatcher *URLResponseClassMatcher;

/**
 The managed object context used to insert model objects.
 */
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

/**
 The class used to create responses. Must be `OVCResponse` or a subclass.
 */
@property (nonatomic, readonly) Class responseClass;

/**
 The model class for server error responses.
 */
@property (nonatomic, readonly) Class errorModelClass;

/**
 Creates and returns model serializer.
 */
+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)URLMatcher
                 responseClassURLMatcher:(OVCURLMatcher *)URLResponseClassMatcher
                    managedObjectContext:(NSManagedObjectContext *)managedObjectContext
                           responseClass:(Class)responseClass
                         errorModelClass:(Class)errorModelClass;

@end
