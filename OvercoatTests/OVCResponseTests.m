//
//  OVCResponseTests.m
//  Overcoat
//
//  Created by guille on 17/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Overcoat/Overcoat.h>

#import "OVCTestResponse.h"
#import "OVCTestModel.h"

@interface OVCResponseTests : XCTestCase

@property (strong, nonatomic) NSHTTPURLResponse *HTTPResponse;

@end

@implementation OVCResponseTests

- (void)setUp {
    [super setUp];
    
    self.HTTPResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://test"]
                                                    statusCode:200
                                                   HTTPVersion:@"1.1"
                                                  headerFields:@{@"Content-Type": @"text/json"}];
}

- (void)tearDown {
    self.HTTPResponse = nil;
    
    [super tearDown];
}

- (void)testNilJSONDictionary {
    OVCResponse *response = [OVCResponse responseWithHTTPResponse:self.HTTPResponse
                                                       JSONObject:nil
                                                      resultClass:[OVCTestModel class]];
    
    XCTAssertEqualObjects(self.HTTPResponse, response.HTTPResponse, @"should initialize HTTP response");
    XCTAssertNil(response.result, @"result should be nil");
}

- (void)testNoResultClass {
    NSDictionary *JSONObject = @{
        @"name": @"Iron Man",
        @"realName": @"Anthony Stark"
    };
    
    OVCResponse *response = [OVCResponse responseWithHTTPResponse:self.HTTPResponse
                                                   JSONObject:JSONObject
                                                      resultClass:nil];
    
    XCTAssertEqualObjects(self.HTTPResponse, response.HTTPResponse, @"should initialize HTTP response");
    XCTAssertEqualObjects(JSONObject, response.result, @"should initialize result to JSON object");
}

- (void)testSingleResultResponse {
    NSDictionary *JSONObject = @{
        @"name": @"Iron Man",
        @"realName": @"Anthony Stark"
    };
    
    OVCResponse *response = [OVCResponse responseWithHTTPResponse:self.HTTPResponse
                                                       JSONObject:JSONObject
                                                      resultClass:[OVCTestModel class]];
    
    XCTAssertEqualObjects(self.HTTPResponse, response.HTTPResponse, @"should initialize HTTP response");
    
    OVCTestModel *expectedModel = [OVCTestModel modelWithDictionary:@{
                                       @"name": @"Iron Man",
                                       @"realName": @"Anthony Stark"
                                   } error:NULL];
    XCTAssertEqualObjects(expectedModel, response.result, @"should transform JSON into a single model");
}

- (void)testMultipleResultResponse {
    NSArray *JSONObject = @[
        @{
            @"name": @"Iron Man",
            @"realName": @"Anthony Stark"
        },
        @{
            @"name": @"Batman",
            @"realName": @"Bruce Wayne"
        }
    ];
    
    OVCResponse *response = [OVCResponse responseWithHTTPResponse:self.HTTPResponse
                                                       JSONObject:JSONObject
                                                      resultClass:[OVCTestModel class]];
    
    XCTAssertEqualObjects(self.HTTPResponse, response.HTTPResponse, @"should initialize HTTP response");
    
    NSArray *expectedModels = @[
        [OVCTestModel modelWithDictionary:@{
             @"name": @"Iron Man",
             @"realName": @"Anthony Stark"
         } error:NULL],
        [OVCTestModel modelWithDictionary:@{
             @"name": @"Batman",
             @"realName": @"Bruce Wayne"
         } error:NULL]
    ];
    
    XCTAssertEqualObjects(expectedModels, response.result, @"should transform JSON into an array of models");
}

- (void)testCustomResponseClass {
    NSDictionary *JSONObject = @{
        @"status": @"ok",
        @"data": @[
            @{
                @"name": @"Iron Man",
                @"realName": @"Anthony Stark"
            },
            @{
                @"name": @"Batman",
                @"realName": @"Bruce Wayne"
            }
        ]
    };
    
    OVCTestResponse *response = [OVCTestResponse responseWithHTTPResponse:self.HTTPResponse
                                                               JSONObject:JSONObject
                                                              resultClass:[OVCTestModel class]];
    
    XCTAssertEqualObjects(self.HTTPResponse, response.HTTPResponse, @"should initialize HTTP response");
    
    NSArray *expectedModels = @[
        [OVCTestModel modelWithDictionary:@{
             @"name": @"Iron Man",
             @"realName": @"Anthony Stark"
         } error:NULL],
        [OVCTestModel modelWithDictionary:@{
             @"name": @"Batman",
             @"realName": @"Bruce Wayne"
         } error:NULL]
    ];
    
    XCTAssertEqualObjects(expectedModels, response.result, @"should transform the contents of 'data' into an array of models");
    
    XCTAssertEqualObjects(@"ok", response.status, @"should initialize metadata");
}

@end
