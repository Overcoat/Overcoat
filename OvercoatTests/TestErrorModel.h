//
//  TestErrorModel.h
//  Overcoat
//
//  Created by alleus on 2014-02-11.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TestErrorModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *errorName;
@property (copy, nonatomic) NSNumber *errorCode;

+ (instancetype)testErrorModelWithErrorName:(NSString *)errorName errorCode:(NSNumber *)errorCode;

@end
