//
//  OVCHTTPRequestOperationManagerTests.m
//  Overcoat
//
//  Created by guille on 14/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OVercoat/Overcoat.h>

@interface OVCHTTPRequestOperationManagerTests : XCTestCase

@end

@implementation OVCHTTPRequestOperationManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testResponseClass {
    XCTAssertEqualObjects([OVCHTTPRequestOperationManager responseClass], [OVCResponse class], @"should return OVCResponse");
}

- (void)testModelClassesByResourcePathMustBeOverridenBySubclass {
    XCTAssertThrows([OVCHTTPRequestOperationManager modelClassesByResourcePath], @"should throw an exception");
}

@end
