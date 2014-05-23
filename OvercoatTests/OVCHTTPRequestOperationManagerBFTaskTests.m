//
//  OVCHTTPRequestOperationManagerBFTaskTests.m
//  Overcoat
//
//  Created by guille on 23/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Overcoat/Overcoat.h>
#import <Overcoat/Bolts+Overcoat.h>

#import "TGRAsyncTestHelper.h"
#import "OVCTestModel.h"

#pragma mark - BoltsTestClient

@interface BoltsTestClient : OVCHTTPRequestOperationManager

@end

@implementation BoltsTestClient

+ (Class)errorModelClass {
    return [OVCErrorModel class];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
               @"model/#": [OVCTestModel class],
               @"models": [OVCTestModel class]
    };
}

@end

#pragma mark - OVCHTTPRequestOperationManagerBFTaskTests

@interface OVCHTTPRequestOperationManagerBFTaskTests : XCTestCase

@property (strong, nonatomic) BoltsTestClient *client;

@end

@implementation OVCHTTPRequestOperationManagerBFTaskTests

- (void)setUp {
    [super setUp];
    self.client = [[BoltsTestClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://test/v1/"]];
}

- (void)tearDown {
    [self.client cancelAllRequests];
    
    self.client = nil;
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testGET {
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFileInBundle(@"model.json", nil);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    OVCResponse * __block response = nil;
    NSError * __block error = nil;
    
    [[self.client bf_GET:@"model/42" parameters:nil] continueWithBlock:^id(BFTask *task) {
        response = task.result;
        error = task.error;
        return nil;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"GET", request.HTTPMethod, @"should send a GET request");
}

- (void)testGETServerError {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFileInBundle(@"error.json", nil);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    OVCResponse * __block response = nil;
    NSError * __block error = nil;
    
    [[self.client bf_GET:@"model/42" parameters:nil] continueWithBlock:^id(BFTask *task) {
        response = task.result;
        error = task.error;
        return nil;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testGETError {
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSError *error = [NSError errorWithDomain:NSURLErrorDomain
                                             code:NSURLErrorNotConnectedToInternet
                                         userInfo:nil];
        return [OHHTTPStubsResponse responseWithError:error];
    }];
    
    OVCResponse * __block response = nil;
    NSError * __block error = nil;
    
    [[self.client bf_GET:@"model/42" parameters:nil] continueWithBlock:^id(BFTask *task) {
        response = task.result;
        error = task.error;
        return nil;
    }];
    
    TGRAssertEventually(error, @"should complete with an error");
    XCTAssertNil(response, @"should not return a response");
}

- (void)testHEAD {
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:nil
                                          statusCode:200
                                             headers:@{@"Content-Type": @"application/json"}];
    }];
    
    OVCResponse * __block response = nil;
    NSError * __block error = nil;
    
    [[self.client bf_HEAD:@"models" parameters:@{@"foo": @"bar"}] continueWithBlock:^id(BFTask *task) {
        response = task.result;
        error = task.error;
        return nil;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertNil(response.result, @"should return an empty response");
    
    XCTAssertEqualObjects(@"HEAD", request.HTTPMethod, @"should send a HEAD request");
}

@end
