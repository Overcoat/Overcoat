//
//  OVCURLMatcherTests.m
//  Overcoat
//
//  Created by guille on 16/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Overcoat/Overcoat.h>

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
        @"alternative": [OVCAlternativeModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:nil
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/test"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");
    
    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/alternative"]];
    XCTAssertEqualObjects([OVCAlternativeModel class], modelClass, @"should return OVCAlternativeTestModel class");
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
        @"test/*": [OVCTestModel class],
        @"test2/**": [OVCAlternativeModel class],
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  modelClassesByPath:modelClassesByPath];
    
    Class modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/whatever42"]];
    XCTAssertEqualObjects([OVCTestModel class], modelClass, @"should return OVCTestModel class");

    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/whatever/42"]];
    XCTAssertNil(modelClass, @"should not find a matching model");

    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test2/whatever42"]];
    XCTAssertEqualObjects([OVCAlternativeModel class], modelClass, @"should return OVCTestModel class");

    modelClass = [matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test2/whatever/42"]];
    XCTAssertEqualObjects([OVCAlternativeModel class], modelClass, @"should return OVCTestModel class");
}

- (void)testWildcardAsFallback {
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  modelClassesByPath:nil];
    [matcher addModelClass:[OVCAlternativeModel class] forPath:@"test/*"];
    [matcher addModelClass:[OVCTestModel class] forPath:@"test/path/sub"];
    [matcher addModelClass:[OVCTestModel2 class] forPath:@"test/path/under"];
    [matcher addModelClass:[MTLModel class] forPath:@"test"];

    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/path/sub"]],
                          [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/path/under"]],
                          [OVCTestModel2 class]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/apple"]],
                          [OVCAlternativeModel class]);
    XCTAssertNil([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/apple/osx"]]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test"]],
                          [MTLModel class]);
    XCTAssertNil([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/"]]);
}

- (void)testFallback {
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:@"/api/v1"
                                                  matcherNodesByPath:@{
        @"test/*": [OVCURLMatcherNode matcherNodeWithModelClass:[OVCTestModel class]],
        @"test/#": [OVCURLMatcherNode matcherNodeWithModelClass:[MTLModel class]],
        @"test/**": [OVCURLMatcherNode matcherNodeWithModelClass:[OVCTestModel2 class]],
        @"**": [OVCURLMatcherNode matcherNodeWithModelClass:[OVCAlternativeModel class]],
    }];

    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/apple"]],
                          [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/42"]],
                          [MTLModel class]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/test/apple/seed"]],
                          [OVCTestModel2 class]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/models"]],
                          [OVCAlternativeModel class]);
    XCTAssertEqualObjects([matcher modelClassForURL:[NSURL URLWithString:@"http://example.com/api/v1/"]],
                          [OVCAlternativeModel class]);
}

- (void)testModelClassByResponseStatusCode1 {
    OVCURLMatcher *matcher = [OVCURLMatcher matcherWithBasePath:@"/api/v1" modelClassesByPath:@{
        @"test/**": @{
            @200: [OVCTestModel class],
            @201: [OVCAlternativeModel class],
        }
    }];

    NSURL *url = [NSURL URLWithString:@"http://example.com/api/v1/test/path/sub"];
    NSHTTPURLResponse *res200 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:200
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    NSHTTPURLResponse *res201 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:201
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    NSHTTPURLResponse *res404 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:404
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];

    XCTAssertNil([matcher modelClassForURL:url]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:nil andURLResponse:res200], [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:nil andURLResponse:res201], [OVCAlternativeModel class]);
    XCTAssertNil([matcher modelClassForURLRequest:nil andURLResponse:res404]);
}

- (void)testModelClassByResponseStatusCode2 {
    OVCURLMatcher *matcher = [OVCURLMatcher matcherWithBasePath:@"/api/v1" matcherNodesByPath:@{
        @"test/**": [OVCURLMatcherNode matcherNodeWithResponseCode:@{
            @200: [OVCTestModel class],
            @201: [OVCAlternativeModel class],
        }],
    }];

    NSURL *url = [NSURL URLWithString:@"http://example.com/api/v1/test/path/sub"];
    NSHTTPURLResponse *res200 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:200
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    NSHTTPURLResponse *res201 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:201
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    NSHTTPURLResponse *res404 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:404
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    
    XCTAssertNil([matcher modelClassForURL:url]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:nil andURLResponse:res200], [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:nil andURLResponse:res201], [OVCAlternativeModel class]);
    XCTAssertNil([matcher modelClassForURLRequest:nil andURLResponse:res404]);
}

- (void)testModelClassByRequestMethod1 {
    OVCURLMatcher *matcher = [OVCURLMatcher matcherWithBasePath:@"/api/v1" modelClassesByPath:@{
        @"test/**": @{
            @"GET": [OVCTestModel class],
            @"POST": [OVCAlternativeModel class],
        }
    }];

    NSURL *url = [NSURL URLWithString:@"http://example.com/api/v1/test/path/sub"];
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    getRequest.HTTPMethod = @"GET";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    postRequest.HTTPMethod = @"POST";
    NSMutableURLRequest *putRequest = [NSMutableURLRequest requestWithURL:url];
    putRequest.HTTPMethod = @"PUT";
    
    XCTAssertNil([matcher modelClassForURL:url]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:getRequest andURLResponse:nil], [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:postRequest andURLResponse:nil], [OVCAlternativeModel class]);
    XCTAssertNil([matcher modelClassForURLRequest:putRequest andURLResponse:nil]);
}

- (void)testModelClassByRequestMethod2 {
    OVCURLMatcher *matcher = [OVCURLMatcher matcherWithBasePath:@"/api/v1" matcherNodesByPath:@{
        @"test/**": [OVCURLMatcherNode matcherNodeWithRequestMethod:@{
            @"GET": [OVCTestModel class],
            @"POST": [OVCAlternativeModel class],
        }]
    }];

    NSURL *url = [NSURL URLWithString:@"http://example.com/api/v1/test/path/sub"];
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    getRequest.HTTPMethod = @"GET";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    postRequest.HTTPMethod = @"POST";
    NSMutableURLRequest *putRequest = [NSMutableURLRequest requestWithURL:url];
    putRequest.HTTPMethod = @"PUT";
    
    XCTAssertNil([matcher modelClassForURL:url]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:getRequest andURLResponse:nil], [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:postRequest andURLResponse:nil], [OVCAlternativeModel class]);
    XCTAssertNil([matcher modelClassForURLRequest:putRequest andURLResponse:nil]);
}

- (void)testModelClassByBlock {
    OVCURLMatcher *matcher = [OVCURLMatcher matcherWithBasePath:@"/api/v1" matcherNodesByPath:@{
        @"test/**": [OVCURLMatcherNode matcherNodeWithBlock:^Class(NSURLRequest *req, NSHTTPURLResponse *res) {
            if ([req.HTTPMethod isEqualToString:@"GET"] && res.statusCode == 200) {
                return [OVCTestModel class];
            } else if ([req.HTTPMethod isEqualToString:@"POST"] && res.statusCode == 201) {
                return [OVCAlternativeModel class];
            }
            return [OVCTestModel2 class];
        }],
    }];

    NSURL *url = [NSURL URLWithString:@"http://example.com/api/v1/test/path/sub"];

    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    getRequest.HTTPMethod = @"GET";
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url];
    postRequest.HTTPMethod = @"POST";
    NSMutableURLRequest *putRequest = [NSMutableURLRequest requestWithURL:url];
    putRequest.HTTPMethod = @"PUT";

    NSHTTPURLResponse *res200 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:200
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    NSHTTPURLResponse *res201 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:201
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];
    NSHTTPURLResponse *res404 = [[NSHTTPURLResponse alloc] initWithURL:url
                                                            statusCode:404
                                                           HTTPVersion:@"HTTP/1.1"
                                                          headerFields:nil];

    XCTAssertEqualObjects([matcher modelClassForURL:url], [OVCTestModel2 class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:getRequest andURLResponse:res200], [OVCTestModel class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:getRequest andURLResponse:res201], [OVCTestModel2 class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:postRequest andURLResponse:res200], [OVCTestModel2 class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:postRequest andURLResponse:res201],
                          [OVCAlternativeModel class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:putRequest andURLResponse:res200], [OVCTestModel2 class]);
    XCTAssertEqualObjects([matcher modelClassForURLRequest:putRequest andURLResponse:res404], [OVCTestModel2 class]);
}

@end
