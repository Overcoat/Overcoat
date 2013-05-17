//
//  TestModel.h
//  Overcoat
//
//  Created by guille on 13/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TestModel : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *lastName;

+ (instancetype)testModelWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;

@end
