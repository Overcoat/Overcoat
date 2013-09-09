// OVCRequestOperation.h
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

// AFJSONRequestOperation subclass for downloading and transforming JSON data into model objects.
@interface OVCRequestOperation : AFJSONRequestOperation

// Transforms the JSON response into a model object or an array of model objects.
@property (strong, nonatomic) NSValueTransformer *valueTransformer;

// Single model object or array of model objects constructed from the JSON response.
@property (strong, nonatomic, readonly) id responseObject;

// Creates a `NSValueTransformer` object that takes the value of the specified keyPath from the
// input object and transforms it into an instance or an array of instances of the specified
// MTLModel subclass.
+ (NSValueTransformer *)valueTransformerWithResultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath;

// Initializes the receiver with the specified url request, result model class and result object key path.
- (id)initWithRequest:(NSURLRequest *)urlRequest resultClass:(Class)resultClass resultKeyPath:(NSString *)keyPath;

@end

@interface OVCRequestOperation (Unavailable)

@property (copy, nonatomic) id (^transformBlock)(id obj) __attribute__((deprecated("Replaced by OVCRequestOperation.valueTransformer")));

- (id)initWithRequest:(NSURLRequest *)urlRequest transformBlock:(id (^)(id obj))transformBlock __attribute__((deprecated("Replaced by -initWithRequest:resultClass:resultKeyPath:")));

@end
