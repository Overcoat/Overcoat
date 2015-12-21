// OVCManagedModelResponseSerializer.h
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

#import <Overcoat/OVCModelResponseSerializer.h>

@class NSManagedObjectContext;

NS_ASSUME_NONNULL_BEGIN

/**
 AFJSONResponseSerializer subclass that validates and transforms a JSON response into a
 `OVCResponse` object.
 */
@interface OVCManagedModelResponseSerializer : OVCModelResponseSerializer

/**
 The managed object context used to insert model objects.
 */
@property (strong, nonatomic, OVC_NULLABLE) NSManagedObjectContext *managedObjectContext;

/**
 Creates and returns model serializer.
 */
+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)URLMatcher
                           responseClass:(OVC_NULLABLE Class)responseClass
                         errorModelClass:(OVC_NULLABLE Class)errorModelClass
                    managedObjectContext:(OVC_NULLABLE NSManagedObjectContext *)managedObjectContext;

+ (instancetype)serializerWithURLMatcher:(OVCURLMatcher *)URLMatcher
                 responseClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)responseClassURLMatcher
               errorModelClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)errorModelClassURLMatcher
                    managedObjectContext:(OVC_NULLABLE NSManagedObjectContext *)managedObjectContext;

- (instancetype)initWithURLMatcher:(OVCURLMatcher *)URLMatcher
           responseClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)responseClassURLMatcher
         errorModelClassURLMatcher:(OVC_NULLABLE OVCURLMatcher *)errorModelClassURLMatcher
              managedObjectContext:(OVC_NULLABLE NSManagedObjectContext *)context NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
