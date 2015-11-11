//
//  OVCCoreDataTestModel.m
//  Overcoat
//
//  Created by sodas on 11/11/15.
//
//

#import "OVCCoreDataTestModel.h"

@implementation OVCManagedTestModel

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

@implementation OVCManagedAlternativeModel

@dynamic objects;

+ (NSString *)managedObjectSerializingKeyPath {
    return @"objects";
}

+ (NSValueTransformer *)objectsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OVCManagedTestModel class]];
}

@end
