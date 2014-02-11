//
//  TestErrorModel.m
//  Overcoat
//
//  Created by alleus on 2014-02-11.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "TestErrorModel.h"

@implementation TestErrorModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"errorName" : @"error_name",
             @"errorCode" : @"error_code",
    };
}

+ (instancetype)testErrorModelWithErrorName:(NSString *)errorName errorCode:(NSNumber *)errorCode {
    TestErrorModel *testErrorModel = [[self alloc] init];
    testErrorModel.errorName = errorName;
    testErrorModel.errorCode = errorCode;
    
    return testErrorModel;
}

@end
