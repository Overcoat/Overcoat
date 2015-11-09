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
    return @{
        @"name": @"name",
        @"realName": @"realName",
    };
}

+ (NSString *)managedObjectEntityName {
    return @"TestModel";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{
        @"name": @"name",
        @"realName": @"realName",
    };
}

@end

@implementation OVCTestModel2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name": @"name",
        @"realName": @"realName",
    };
}

@end

@implementation OVCErrorModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"status": @"status",
        @"code": @"code",
        @"message": @"message",
    };
}

@end

@implementation OVCAlternativeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"offset": @"offset",
        @"limit": @"limit",
        @"objects": @"objects",
    };
}

+ (NSValueTransformer *)objectsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OVCTestModel class]];
}

+ (NSString *)managedObjectSerializingKeyPath {
    return @"objects";
}

@end
