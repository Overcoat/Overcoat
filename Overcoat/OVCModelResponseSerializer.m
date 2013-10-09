// OVCModelResponseSerializer.m
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

#import "OVCModelResponseSerializer.h"
#import "NSDictionary+Overcoat.h"

#import <Mantle/Mantle.h>

@implementation OVCModelResponseSerializer

+ (instancetype)serializerWithModelClass:(Class)modelClass responseKeyPath:(NSString *)responseKeyPath {
    return [self serializerWithReadingOptions:0 modelClass:modelClass responseKeyPath:responseKeyPath];
}

+ (instancetype)serializerWithReadingOptions:(NSJSONReadingOptions)readingOptions modelClass:(Class)modelClass responseKeyPath:(NSString *)responseKeyPath {
    OVCModelResponseSerializer *serializer = [self serializerWithReadingOptions:readingOptions];
    serializer.modelClass = modelClass;
    serializer.responseKeyPath = responseKeyPath;
    
    return serializer;
}

#pragma mark - AFURLRequestSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error {
    id JSONObject = [super responseObjectForResponse:response data:data error:error];
    
    if (JSONObject != nil) {
        if (self.responseKeyPath.length && [JSONObject isKindOfClass:NSDictionary.class]) {
            JSONObject = [JSONObject ovc_objectForKeyPath:self.responseKeyPath];
        }
        
        if (self.modelClass != Nil) {
            NSValueTransformer *valueTransformer = nil;
            
            if ([JSONObject isKindOfClass:NSDictionary.class]) {
                valueTransformer = [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:self.modelClass];
            }
            else if ([JSONObject isKindOfClass:NSArray.class]) {
                valueTransformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:self.modelClass];
            }
            
            return [valueTransformer transformedValue:JSONObject];
        }
        
        return JSONObject;
    }
    
    return nil;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.modelClass = NSClassFromString([aDecoder decodeObjectForKey:@"modelClass"]);
        self.responseKeyPath = [aDecoder decodeObjectForKey:@"responseKeyPath"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:NSStringFromClass(self.modelClass) forKey:@"modelClass"];
    [aCoder encodeObject:self.responseKeyPath forKey:@"responseKeyPath"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    OVCModelResponseSerializer *serializer = [super copyWithZone:zone];
    serializer.modelClass = self.modelClass;
    serializer.responseKeyPath = self.responseKeyPath;
    
    return serializer;
}

@end
