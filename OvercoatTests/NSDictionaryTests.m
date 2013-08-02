//
//  NSDictionaryTests.m
//  Overcoat
//
//  Created by guille on 13/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

@interface NSDictionaryTests : SenTestCase

@end

@implementation NSDictionaryTests

- (void)testObjectForKeyPath {
    NSDictionary *hero = @{
            @"name" : @"Batman",
            @"secretIdentity" : @{
                    @"firstName" : @"Bruce",
                    @"lastName" : @"Wayne",
                    @"relatives" : @[@"Thomas Wayne", @"Martha Wayne"]
            },
    };

    STAssertEqualObjects([hero ovc_objectForKeyPath:@"name"], @"Batman", nil);
    STAssertEqualObjects([hero ovc_objectForKeyPath:@"secretIdentity.firstName"], @"Bruce", nil);
    STAssertNil([hero ovc_objectForKeyPath:@"secretIdentity.relatives.thomas"], nil);
}

@end
