//
//  OVCHTTPSessionManagerReactiveTests.m
//  Overcoat
//
//  Created by Joan Romano on 28/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import <Overcoat/Overcoat.h>
#import <OvercoatReactiveCocoa/OvercoatReactiveCocoa.h>
#import <ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/RACSignal+Operations.h>

#import "OVCTestModel.h"

#pragma mark - ReactiveSessionManager

@interface ReactiveSessionManager : OVCHTTPSessionManager

@end

@implementation ReactiveSessionManager

+ (NSDictionary *)errorModelClassesByResourcePath {
    return @{@"**": [OVCErrorModel class]};
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
        @"model/#": [OVCTestModel class],
        @"models": [OVCTestModel class]
    };
}

@end

#pragma mark - OVCHTTPSessionManagerReactiveTests

@interface OVCHTTPSessionManagerReactiveTests : XCTestCase

@property (strong, nonatomic) ReactiveSessionManager *client;

@end

@implementation OVCHTTPSessionManagerReactiveTests

- (void)setUp
{
    [super setUp];
    
    self.client = [[ReactiveSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://test/v1/"]];
}

- (void)tearDown
{
    [self.client invalidateSessionCancelingTasks:YES];
    
    self.client = nil;
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testGET_old
{
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[self.client rac_GET:@"model/42" parameters:nil] subscribeNext:^(OVCResponse *r) {
        response = r;
        [completed fulfill];
    }];
#pragma clang diagnostic pop

    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"GET", request.HTTPMethod, @"should send a GET request");
}

- (void)testGETServerError_old
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[self.client rac_GET:@"model/42" parameters:nil] subscribeError:^(NSError *e) {
        error = e;
        [completed fulfill];
    }];
#pragma clang diagnostic pop

    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testGET
{
    NSURLRequest * __block request = nil;

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [[OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}]
                responseTime:0.2];
    }];

    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;
    NSProgress * __block progress = nil;

    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> progress) {

        return [[self.client rac_GET:@"model/42" parameters:nil progress:progress]
                subscribeNext:^(OVCResponse *r) {
                    response = r;
                    [completed fulfill];
                }];
    }] subscribeNext:^(NSProgress *downloadProgress) {
        progress = downloadProgress;
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");

    XCTAssertTrue([progress isKindOfClass:[NSProgress class]], @"progress subscriber should recive progress during downloading");

    XCTAssertEqualObjects(@"GET", request.HTTPMethod, @"should send a GET request");
}

- (void)testGETServerError
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [[OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}]
                responseTime:0.2];
    }];

    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;
    NSError * __block progressError = nil;

    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> progress) {

        return [[self.client rac_GET:@"model/42" parameters:nil progress:progress]
                subscribeError:^(NSError *e) {
                    error = e;
                    [completed fulfill];
                }];
    }] subscribeError:^(NSError *e) {
        progressError = e;
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    OVCResponse *progressResponse = progressError.ovc_response;
    XCTAssertTrue([progressResponse.result isKindOfClass:[OVCErrorModel class]], @"progress subscriber should recive an error model");

    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testHEAD
{
    NSURLRequest * __block request = nil;

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[NSData data]
                                          statusCode:200
                                             headers:@{@"Content-Type": @"application/json"}];
    }];

    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;

    [[self.client rac_HEAD:@"models" parameters:@{@"foo": @"bar"}] subscribeNext:^(OVCResponse *r) {
        response = r;
        [completed fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertNil(response.result, @"should return an empty response");

    XCTAssertEqualObjects(@"HEAD", request.HTTPMethod, @"should send a HEAD request");
}

- (void)testPOST_old
{
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[self.client rac_POST:@"models" parameters:@{@"name": @"Iron Man"}] subscribeNext:^(OVCResponse *r) {
        response = r;
        [completed fulfill];
    }];
#pragma clang diagnostic pop

    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"POST", request.HTTPMethod, @"should send a POST request");
}

- (void)testPOSTServerError_old
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[self.client rac_POST:@"models" parameters:@{@"name": @"Iron Man"}] subscribeError:^(NSError *e) {
        error = e;
        [completed fulfill];
    }];
#pragma clang diagnostic pop

    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testPOST
{
    NSURLRequest * __block request = nil;

    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [[OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}]
                requestTime:0.2 responseTime:0.2];
    }];

    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;
    NSProgress * __block __unused progress = nil; // currently there's no way to test it.

    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> progress) {

        return [[self.client rac_POST:@"models" parameters:@{@"name": @"Iron Man"} progress:progress]
                subscribeNext:^(OVCResponse *r) {
                    response = r;
                    [completed fulfill];
                }];
    }] subscribeNext:^(NSProgress *uploadProgress) {
        progress = uploadProgress;
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");

    /* https://github.com/khanlou/InstantCocoa/tree/master/Pods/OHHTTPStubs#known-limitations

    XCTAssertTrue([progress isKindOfClass:[NSProgress class]], @"progress subscriber should recive progress during uploading");
     */

    XCTAssertEqualObjects(@"POST", request.HTTPMethod, @"should send a POST request");
}

- (void)testPOSTServerError
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];

    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;
    NSError * __block progressError = nil;

    [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> progress) {

        return [[self.client rac_POST:@"models" parameters:@{@"name": @"Iron Man"} progress:progress]
                subscribeError:^(NSError *e) {
                    error = e;
                    [completed fulfill];
                }];
    }] subscribeError:^(NSError *e) {
        progressError = e;
    }];

    [self waitForExpectationsWithTimeout:1 handler:nil];

    OVCResponse *progressResponse = progressError.ovc_response;
    XCTAssertTrue([progressResponse.result isKindOfClass:[OVCErrorModel class]], @"progress subscriber should recive an error model");

    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testPUT
{
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;
    
    [[self.client rac_PUT:@"model/42" parameters:@{@"name": @"Golden Avenger"}] subscribeNext:^(OVCResponse *r) {
        response = r;
        [completed fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"PUT", request.HTTPMethod, @"should send a PUT request");
}

- (void)testPUTServerError
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;
    
    [[self.client rac_PUT:@"model/42" parameters:@{@"name": @"Golden Avenger"}] subscribeError:^(NSError *e) {
        error = e;
        [completed fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testPATCH
{
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;
    
    [[self.client rac_PATCH:@"model/42" parameters:@{@"name": @"Golden Avenger"}] subscribeNext:^(OVCResponse *r) {
        response = r;
        [completed fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"PATCH", request.HTTPMethod, @"should send a PATCH request");
}

- (void)testPATCHServerError
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;
    
    [[self.client rac_PATCH:@"model/42" parameters:@{@"name": @"Golden Avenger"}] subscribeError:^(NSError *e) {
        error = e;
        [completed fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testDELETE
{
    NSURLRequest * __block request = nil;
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *r) {
        request = r;
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"model.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    OVCResponse * __block response = nil;
    
    [[self.client rac_DELETE:@"model/42" parameters:nil] subscribeNext:^(OVCResponse *r) {
        response = r;
        [completed fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"DELETE", request.HTTPMethod, @"should send a DELETE request");
}

- (void)testDELETEServerError
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFile(@"error.json", self.class);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:401
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    XCTestExpectation *completed = [self expectationWithDescription:@"completed"];
    NSError * __block error = nil;
    
    [[self.client rac_DELETE:@"model/42" parameters:nil] subscribeError:^(NSError *e) {
        error = e;
        [completed fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
    
    OVCResponse *response = error.ovc_response;
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

@end
