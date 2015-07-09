// Tweet.m
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

#import "Tweet.h"
#import "TwitterUser.h"
#import "NSDateFormatter+Twitter.h"
#import <Overcoat/OVCUtilities.h>

@implementation Tweet

#if OVERCOAT_USING_MANTLE_2

#pragma mark - Using With Mantle 2.x -

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id",
        @"text": @"text",
        @"createdAt": @"created_at",
        @"retweetedStatus": @"retweeted_status",
        @"user": @"user"
    };
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *stringValue,
                                                                 BOOL *success,
                                                                 NSError *__autoreleasing *error) {
        return [NSDateFormatter dateFromTwitterString:stringValue];
    }];
}

+ (NSValueTransformer *)retweetedStatusJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Tweet class]];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[TwitterUser class]];
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Tweet";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:self];
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
    return @{
        @"retweetedStatus": [Tweet class],
        @"user": [TwitterUser class]
    };
}

#else

#pragma mark - Using With Mantle 1.x -

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id",
        @"createdAt": @"created_at",
        @"retweetedStatus": @"retweeted_status"
    };
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *stringValue) {
        return [NSDateFormatter dateFromTwitterString:stringValue];
    }];
}

+ (NSValueTransformer *)retweetedStatusJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Tweet class]];
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TwitterUser class]];
}

#pragma mark MTLManagedObjectSerializing

+ (NSString *)managedObjectEntityName {
    return @"Tweet";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing {
    return [NSSet setWithObject:@"identifier"];
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey {
    return @{
        @"retweetedStatus": [Tweet class],
        @"user": [TwitterUser class]
    };
}

#endif

@end
