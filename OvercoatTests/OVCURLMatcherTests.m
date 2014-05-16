//
//  OVCURLMatcherTests.m
//  Overcoat
//
//  Created by guille on 16/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "OVCURLMatcher.h"
#import "OVCTestModel.h"

@interface OVCURLMatcherTests : XCTestCase

@end

@implementation OVCURLMatcherTests

- (void)testMatchNotFound {
    OVCURLMatcher *matcher = [OVCURLMatcher new];
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/test"]];
    XCTAssertNil(modelClass, @"should return nil when no match is found");
}

- (void)testMatchFound {
    NSDictionary *modelClassesByPath = @{
        @"test": [OVCTestModel class],
        @"alternative": [OVCAlternativeTestModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:nil
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/test"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");
    
    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/alternative"]];
    XCTAssertEqualObjects([OVCAlternativeTestModel class], modelClass, @"should return OVCAlternativeTestModel class");
}

- (void)testMatchWithBasePath {
    NSDictionary *modelClassesByPath = @{
        @"test": [OVCTestModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");
}

- (void)testMatchEqualNumberOfPathComponents {
    NSDictionary *modelClassesByPath = @{
        @"test/things": [OVCTestModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test"]];
    XCTAssertNil(modelClass, @"should not find a matching model");
    
    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/things"]];
    XCTAssertNil(modelClass, @"should not find a matching model");
    
    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/things/thingys"]];
    XCTAssertNil(modelClass, @"should not find a matching model");
    
    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/things"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");
}

- (void)testDigitsMatcher {
    NSDictionary *modelClassesByPath = @{
        @"test/#": [OVCTestModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/42"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");
    
    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/things"]];
    XCTAssertNil(modelClass, @"should not find a matching model");
}

- (void)testWildcardMatcher {
    NSDictionary *modelClassesByPath = @{
        @"test/*": [OVCTestModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/whatever42"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");
}

@end
