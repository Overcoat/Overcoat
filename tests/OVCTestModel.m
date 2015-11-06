//
//  OVCTestModel.m
//  Overcoat
//
//  Created by guille on 16/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "OVCTestModel.h"

@implementation OVCTestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
#if OVERCOAT_USING_MANTLE_2
    return @{
        @"name": @"name",
        @"realName": @"realName",
    };
#else
    return @{};
#endif
}

+ (NSString *)managedObjectEntityName {
    return @"TestModel";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
#if OVERCOAT_USING_MANTLE_2
    return @{
        @"name": @"name",
        @"realName": @"realName",
    };
#else
    return @{};
#endif
}

@end

@implementation OVCTestModel2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
#if OVERCOAT_USING_MANTLE_2
    return @{
        @"name": @"name",
        @"realName": @"realName",
    };
#else
    return @{};
#endif
}

@end

@implementation OVCErrorModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
#if OVERCOAT_USING_MANTLE_2
    return @{
        @"status": @"status",
        @"code": @"code",
        @"message": @"message",
    };
#else
    return @{};
#endif
}

@end

@implementation OVCAlternativeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
#if OVERCOAT_USING_MANTLE_2
    return @{
        @"offset": @"offset",
        @"limit": @"limit",
        @"objects": @"objects",
    };
#else
    return @{};
#endif
}

+ (NSValueTransformer *)objectsJSONTransformer {
#if OVERCOAT_USING_MANTLE_2
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OVCTestModel class]];
#else
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[OVCTestModel class]];
#endif
}

+ (NSString *)managedObjectSerializingKeyPath {
    return @"objects";
}

@end
