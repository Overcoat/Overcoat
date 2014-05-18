//
//  OVCModelResponseSerializerTests.m
//  Overcoat
//
//  Created by guille on 01/02/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Overcoat/Overcoat.h>

#import "OVCTestModel.h"
#import "OVCTestResponse.h"

@interface OVCModelResponseSerializerTests : XCTestCase

@property (strong, nonatomic) OVCModelResponseSerializer *serializer;

@end

@implementation OVCModelResponseSerializerTests

- (void)setUp {
    [super setUp];
    
    NSDictionary *modelClassesByPath = @{
        @"test": [OVCTestModel class],
        @"alternative": [OVCAlternativeModel class]
    };
    
    OVCURLMatcher *matcher = [[OVCURLMatcher alloc] initWithBasePath:nil
                                                  modelClassesByPath:modelClassesByPath];
    
    self.serializer = [OVCModelResponseSerializer serializerWithURLMatcher:matcher
                                                      managedObjectContext:nil
                                                             responseClass:[OVCResponse class]
                                                           errorModelClass:[OVCErrorModel class]];
}

- (void)tearDown {
    self.serializer = nil;
    
    [super tearDown];
}

- (void)testSuccessResponseSerialization {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                        @"name": @"Iron Man",
                        @"realName": @"Anthony Stark"
                    } options:0 error:NULL];
    NSURLResponse *URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/test"]
                                                             statusCode:200
                                                            HTTPVersion:@"1.1"
                                                           headerFields:@{@"Content-Type": @"text/json"}];
    OVCResponse *response = [self.serializer responseObjectForResponse:URLResponse data:data error:NULL];
    
    XCTAssertTrue([response isKindOfClass:[OVCResponse class]], @"should return a OVCResponse instance");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a OVCTestModel result");
}

- (void)testErrorResponseSerialization {
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                        @"status": @"failed",
                        @"code": @97,
                        @"message": @"Missing signature"
                    } options:0 error:NULL];
    NSURLResponse *URLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com/test"]
                                                             statusCode:401
                                                            HTTPVersion:@"1.1"
                                                           headerFields:@{@"Content-Type": @"text/json"}];
    OVCResponse *response = [self.serializer responseObjectForResponse:URLResponse data:data error:NULL];
    
    XCTAssertTrue([response isKindOfClass:[OVCResponse class]], @"should return a OVCResponse instance");
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return a OVCErrorModel result");
}

- (void)testManagedObjectModelSerialization {
    XCTAssertTrue(NO, @"TODO: implement");
}

@end
