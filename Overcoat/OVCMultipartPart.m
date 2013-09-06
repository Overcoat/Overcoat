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

@implementation OVCMultipartPart

+ (instancetype)partWithData:(NSData *)data name:(NSString *)name type:(NSString *)type filename:(NSString *)filename {
    return [[self alloc] initWithData:data name:name type:type filename:filename];
}

- (id)initWithData:(NSData *)data name:(NSString *)name type:(NSString *)type filename:(NSString *)filename {
    self = [super init];
    if (self) {
        _data = [data copy];
        _name = [name copy];
        _type = [type copy];
        _filename = [filename copy];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    // As we are immutable, returning self is enough
    return self;
}

@end
