//
//  TestModel.m
//  Overcoat
//
//  Created by guille on 13/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"firstName" : @"first_name",
            @"lastName" : @"last_name",
    };
}

+ (instancetype)testModelWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    TestModel *testModel = [[self alloc] init];
    testModel.firstName = firstName;
    testModel.lastName = lastName;

    return testModel;
}

@end
