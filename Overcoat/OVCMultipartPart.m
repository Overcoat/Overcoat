// OVCMultipartPart.m
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

#import "OVCMultipartPart.h"

@interface OVCMultipartPart ()

+ (NSArray *)propertyKeys;

@end

@implementation OVCMultipartPart

- (id)initWithData:(NSData *)data name:(NSString *)name type:(NSString *)type filename:(NSString *)filename {
    self = [super init];
    if (self) {
        _data = data;
        _name = [name copy];
        _type = [type copy];
        _filename = [filename copy];
    }

    return self;
}

- (NSUInteger)hash {
    NSUInteger value = 0;

    for (NSString *key in [[self class] propertyKeys]) {
        value ^= [[self valueForKey:key] hash];
    }

    return value;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (![other isMemberOfClass:[self class]]) {
        return NO;
    }

    for (NSString *key in [[self class] propertyKeys]) {
        id selfValue = [self valueForKey:key];
        id otherValue = [other valueForKey:key];

        BOOL valuesEqual = ((selfValue == nil && otherValue == nil) || [selfValue isEqual:otherValue]);
        if (!valuesEqual) return NO;
    }

    return YES;
}

#pragma mark - Private methods

+ (NSArray *)propertyKeys {
    static dispatch_once_t onceToken;
    static NSArray *propertyKeys;

    dispatch_once(&onceToken, ^{
        propertyKeys = @[@"data", @"name", @"type", @"filename"];
    });

    return propertyKeys;
}

@end
