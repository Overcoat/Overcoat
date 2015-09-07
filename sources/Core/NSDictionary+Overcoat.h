// NSDictionary+Overcoat.h
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
#import <Overcoat/OVCUtilities.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary OVCGenerics(KeyType, ObjectType) (Overcoat)

/**
 *  Returns the value associated with a given key path.
 *
 *  For example, a dictionary like
 *
 *    NSDictionary *someDict = @{
 *        @"dict": @{
 *            @"answer": @42,
 *        },
 *    };
 *    id answer = [someDict ovc_objectForKeyPath:@"dict.answer"];
 *
 *  The value of answer variable would be 42.
 *
 *  @param keyPath The key path for which to return the corresponding value.
 *
 *  @return The value associated with keyPath, or nil if no value is associated with keyPath.
 */
- (OVC_NULLABLE OVCGenericType(ObjectType, id))ovc_objectForKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
