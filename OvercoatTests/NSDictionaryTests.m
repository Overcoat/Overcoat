//
//  NSDictionaryTests.m
//  Overcoat
//
//  Created by guille on 01/02/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

@interface NSDictionaryTests : XCTestCase

@end

@implementation NSDictionaryTests

- (void)testObjectForKeyPath {
    NSDictionary *hero = @{
        @"name": @"Batman",
        @"secretIdentity": @{
            @"firstName": @"Bruce",
            @"lastName": @"Wayne",
            @"relatives": @[@"Thomas Wayne", @"Martha Wayne"]
        },
    };
    
    XCTAssertEqualObjects(@"Batman", [hero ovc_objectForKeyPath:@"name"], @"");
    XCTAssertEqualObjects(@"Bruce", [hero ovc_objectForKeyPath:@"secretIdentity.firstName"], @"");
    XCTAssertNil([hero ovc_objectForKeyPath:@"secretIdentity.relatives.thomas"], @"");
}

@end
