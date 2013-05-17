// OVCQuery.m
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

#import "OVCQuery.h"
#import "OVCMultipartPart.h"
#import "NSDictionary+Overcoat.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface OVCQuery ()

@property (strong, nonatomic, readwrite) NSArray *parts;

@end

@implementation OVCQuery

+ (OVCTransformBlock)transformBlockWithModelClass:(Class)modelClass objectKeyPath:(NSString *)keyPath {
    return ^id(id response) {
        NSValueTransformer *transformer = nil;
        id object = response;

        if ([keyPath length] && [object isKindOfClass:[NSDictionary class]]) {
            object = [object ovc_objectForKeyPath:keyPath];
        }

        if ([object isKindOfClass:[NSDictionary class]]) {
            transformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:modelClass];
        }
        else if ([object isKindOfClass:[NSArray class]]) {
            transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:modelClass];
        }

        return [transformer transformedValue:object];
    };
}

+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path {
    return [self queryWithMethod:method path:path modelClass:nil];
}

+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self queryWithMethod:method path:path parameters:parameters modelClass:nil];
}

+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path modelClass:(Class)modelClass {
    return [self queryWithMethod:method path:path parameters:nil modelClass:modelClass];
}

+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass {
    return [self queryWithMethod:method path:path parameters:parameters modelClass:modelClass objectKeyPath:nil];
}

+ (instancetype)queryWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass objectKeyPath:(NSString *)keyPath {
    OVCTransformBlock transformBlock = (modelClass != nil) ? [self transformBlockWithModelClass:modelClass objectKeyPath:keyPath] : nil;
    return [[self alloc] initWithMethod:method path:path parameters:parameters transformBlock:transformBlock];
}

- (id)initWithMethod:(OVCQueryMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters transformBlock:(OVCTransformBlock)transformBlock {
    self = [super init];
    if (self) {
        _method = method;
        _path = [path copy];
        _parameters = [parameters copy];
        _transformBlock = [transformBlock copy];
    }

    return self;
}

- (void)addMultipartData:(NSData *)data withName:(NSString *)name type:(NSString *)mimeType filename:(NSString *)filename {
    OVCMultipartPart *part = [[OVCMultipartPart alloc] initWithData:data name:name type:mimeType filename:filename];

    NSMutableArray *parts = [NSMutableArray arrayWithArray:self.parts];
    [parts addObject:part];

    self.parts = [NSArray arrayWithArray:parts];
}

@end
