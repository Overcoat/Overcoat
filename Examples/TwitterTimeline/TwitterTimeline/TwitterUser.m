// TwitterUser.m
//
// Copyright (c) 2014 Guillermo Gonzalez
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

#import "TwitterUser.h"
#import <Overcoat/OVCUtilities.h>

@implementation TwitterUser

#if OVERCOAT_USING_MANTLE_2

#pragma mark - Using With Mantle 2.x -

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id",
        @"name": @"name",
        @"screenName": @"screen_name",
        @"profileImageURL": @"profile_image_url"
    };
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"TwitterUser";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

#else

#pragma mark - Using With Mantle 1.x -

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id",
        @"screenName": @"screen_name",
        @"profileImageURL": @"profile_image_url"
    };
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"TwitterUser";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

#endif

@end
