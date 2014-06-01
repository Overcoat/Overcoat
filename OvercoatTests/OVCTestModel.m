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
    return @{};
}

+ (NSString *)managedObjectEntityName {
    return @"TestModel";
}

+ (NSDictionary *)managedObjectKeysByPropertyKey {
    return @{};
}

@end

@implementation OVCErrorModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

@end

@implementation OVCAlternativeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (NSValueTransformer *)objectsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[OVCTestModel class]];
}

+ (NSString *)managedObjectSerializingKeyPath {
    return @"objects";
}

@end
