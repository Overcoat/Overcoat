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

/**
 AFJSONResponseSerializer subclass that validates and transforms a JSON response into a model object or an array of model objects.
 */
@interface OVCModelResponseSerializer : AFJSONResponseSerializer

/**
 MTLModel subclass in which the response (or part of the response) will be transformed.
 */
@property (nonatomic) Class modelClass;

/**
 Key path in the JSON response that contains the data to be transformed.
 */
@property (copy, nonatomic) NSString *responseKeyPath;

/**
 Creates and returns a model serializer with the specified model class and response key path.
 */
+ (instancetype)serializerWithModelClass:(Class)modelClass responseKeyPath:(NSString *)responseKeyPath;

/**
 Creates and returns a model serializer with the specified JSON reading options, model class and response object key path.
 */
+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions
                                  modelClass:(Class)modelClass
                             responseKeyPath:(NSString *)responseKeyPath;

@end
