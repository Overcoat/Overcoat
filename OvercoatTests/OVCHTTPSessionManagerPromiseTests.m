//
//  OVCHTTPSessionManagerPromiseTests.m
//  Overcoat
//
//  Created by guille on 26/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <Overcoat/Overcoat.h>
#import <Overcoat/PromiseKit+Overcoat.h>

#import "TGRAsyncTestHelper.h"
#import "OVCTestModel.h"

#pragma mark - PromiseSessionManager

@interface PromiseSessionManager : OVCHTTPSessionManager

@end

@implementation PromiseSessionManager

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

#pragma mark - OVCHTTPSessionManagerPromiseTests

@interface OVCHTTPSessionManagerPromiseTests : XCTestCase

@property (strong, nonatomic) PromiseSessionManager *client;

@end

@implementation OVCHTTPSessionManagerPromiseTests

- (void)setUp {
    [super setUp];
    self.client = [[PromiseSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://test/v1/"]];
}

- (void)tearDown {
    [self.client invalidateSessionCancelingTasks:YES];
    
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
    
    [self.client GET:@"model/42" parameters:nil].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
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
    
    [self.client GET:@"model/42" parameters:nil].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(error, @"should complete with an error");
    
    response = [error ovc_response];
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
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
    
    [self.client HEAD:@"models" parameters:@{@"foo": @"bar"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertNil(response.result, @"should return an empty response");
    
    XCTAssertEqualObjects(@"HEAD", request.HTTPMethod, @"should send a HEAD request");
}

- (void)testPOST {
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
    
    [self.client POST:@"models" parameters:@{@"name": @"Iron Man"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"POST", request.HTTPMethod, @"should send a POST request");
}

- (void)testPOSTServerError {
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
    
    [self.client POST:@"models" parameters:@{@"name": @"Iron Man"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(error, @"should complete with an error");
    
    response = [error ovc_response];
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testPUT {
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
    
    [self.client PUT:@"model/42" parameters:@{@"name": @"Golden Avenger"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"PUT", request.HTTPMethod, @"should send a PUT request");
}

- (void)testPUTServerError {
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
    
    [self.client PUT:@"model/42" parameters:@{@"name": @"Golden Avenger"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(error, @"should complete with an error");
    
    response = [error ovc_response];
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testPATCH {
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
    
    [self.client PATCH:@"model/42" parameters:@{@"name": @"Golden Avenger"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"PATCH", request.HTTPMethod, @"should send a PATCH request");
}

- (void)testPATCHServerError {
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
    
    [self.client PATCH:@"model/42" parameters:@{@"name": @"Golden Avenger"}].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(error, @"should complete with an error");
    
    response = [error ovc_response];
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testDELETE {
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
    
    [self.client DELETE:@"model/42" parameters:nil].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"DELETE", request.HTTPMethod, @"should send a DELETE request");
}

- (void)testDELETEServerError {
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
    
    [self.client DELETE:@"model/42" parameters:nil].then(^(OVCResponse *r) {
        response = r;
    }).catch(^(NSError *e) {
        error = e;
    });
    
    TGRAssertEventually(error, @"should complete with an error");
    
    response = [error ovc_response];
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

@end
