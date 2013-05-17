// OVCQuery.h
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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OVCQueryMethod) {
    OVCQueryMethodGet,
    OVCQueryMethodPost,
    OVCQueryMethodPut,
    OVCQueryMethodDelete
};

typedef id (^OVCTransformBlock)(id obj);

//
// A REST query that allows specifying how responses are transformed into model objects.
//
@interface OVCQuery : NSObject

// Query method.
@property (nonatomic) OVCQueryMethod method;

// Query path.
@property (copy, nonatomic) NSString *path;

// Query parameters.
@property (copy, nonatomic) NSDictionary *parameters;

// Multipart parts.
@property (strong, nonatomic, readonly) NSArray *parts;

// Transforms this query response into a model object or an array of model objects.
@property (copy, nonatomic) OVCTransformBlock transformBlock;

// Returns a block that transforms the data read from the response at
// the given key path into a model object or an array of model objects
// of the specified class.
//
// If keyPath is nil the data is read directly from the response.
+ (OVCTransformBlock)transformBlockWithModelClass:(Class)modelClass objectKeyPath:(NSString *)keyPath;

// Creates and returns new instance of the receiver and sets the specified method and path.
+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path;

// Creates and returns new instance of the receiver and sets the specified method, path and parameters.
+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters;

// Creates and returns new instance of the receiver and sets the specified method, path and model class.
//
// The response received when executing the returned query will be transformed into an instance or
// an array of instances of the specified model class.
+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path modelClass:(Class)modelClass;

// Creates and returns new instance of the receiver and sets the specified method, path, parameters and model class.
//
// The response received when executing the returned query will be transformed into an instance or
// an array of instances of the specified model class.
+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass;

// Creates and returns new instance of the receiver and sets the specified method, path, parameters, model class and object key path.
//
// The data read from the response at the given key path will be transformed into an instance or an array of instances of the specified model class.
+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass objectKeyPath:(NSString *)keyPath;

// Initializes an 'OVCQuery' object.
//
// method         - The method to use for this query.
// path           - Resource path for this query.
// parameters     - The parameters for this query.
// transformBlock - A block that transforms the response for this query into a model object.
//
// This is the designated initializer.
- (id)initWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters transformBlock:(OVCTransformBlock)transformBlock;

// Specifies a named multipart form data for this query.
//
// data     - The data to be appended.
// name     - The name to be associated with the specified data.
// mimeType - The MIME type of the specified data.
// filename - The filename to be associated with the specified data.
- (void)addMultipartData:(NSData *)data withName:(NSString *)name type:(NSString *)mimeType filename:(NSString *)filename;

@end
