//
//  OVCHTTPRequestOperationManagerTests.m
//  Overcoat
//
//  Created by guille on 14/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OVercoat/Overcoat.h>

#import "TGRAsyncTestHelper.h"
#import "OVCTestModel.h"

#pragma mark - TestClient

@interface TestClient : OVCHTTPRequestOperationManager

@end

@implementation TestClient

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

#pragma mark - OVCHTTPRequestOperationManagerTests

@interface OVCHTTPRequestOperationManagerTests : XCTestCase

@property (strong, nonatomic) TestClient *client;

@end

@implementation OVCHTTPRequestOperationManagerTests

- (void)setUp {
    [super setUp];
    self.client = [[TestClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://test/v1/"]];
}

- (void)tearDown {
    [self.client cancelAllRequests];
    
    self.client = nil;
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testResponseClass {
    XCTAssertEqualObjects([OVCHTTPRequestOperationManager responseClass], [OVCResponse class], @"should return OVCResponse");
}

- (void)testErrorResultClass {
    XCTAssertNil([OVCHTTPRequestOperationManager errorModelClass], @"should be Nil");
}

- (void)testModelClassesByResourcePathMustBeOverridenBySubclass {
    XCTAssertThrows([OVCHTTPRequestOperationManager modelClassesByResourcePath], @"should throw an exception");
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
    
    [self.client GET:@"model/42" parameters:nil completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"GET", request.HTTPMethod, @"should send a GET request");
}

- (void)testGETError {
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
    
    [self.client GET:@"model/42" parameters:nil completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNotNil(error, @"should return an error");
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
    
    [self.client HEAD:@"models" parameters:@{@"foo": @"bar"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
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
    
    [self.client POST:@"models" parameters:@{@"name": @"Iron Man"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"POST", request.HTTPMethod, @"should send a POST request");
}

- (void)testPOSTError {
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
    
    [self.client POST:@"models" parameters:@{@"name": @"Iron Man"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNotNil(error, @"should return an error");
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
    
    [self.client PUT:@"model/42" parameters:@{@"name": @"Golden Avenger"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"PUT", request.HTTPMethod, @"should send a PUT request");
}

- (void)testPUTError {
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
    
    [self.client PUT:@"model/42" parameters:@{@"name": @"Golden Avenger"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNotNil(error, @"should return an error");
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
    
    [self.client PATCH:@"model/42" parameters:@{@"name": @"Golden Avenger"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"PATCH", request.HTTPMethod, @"should send a PATCH request");
}

- (void)testPATCHError {
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
    
    [self.client PATCH:@"model/42" parameters:@{@"name": @"Golden Avenger"} completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNotNil(error, @"should return an error");
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
    
    [self.client DELETE:@"model/42" parameters:nil completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCTestModel class]], @"should return a test model");
    
    XCTAssertEqualObjects(@"DELETE", request.HTTPMethod, @"should send a DELETE request");
}

- (void)testDELETEError {
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
    
    [self.client DELETE:@"model/42" parameters:nil completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNotNil(error, @"should return an error");
    XCTAssertTrue([response.result isKindOfClass:[OVCErrorModel class]], @"should return an error model");
}

- (void)testCoreDataSerialization {
    // Setup the Core Data stack
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    OVCManagedStore *store = [OVCManagedStore managedStoreWithModel:model];
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:store.persistentStoreCoordinator];
    
    // Observe changes in Core Data
    
    NSNotification * __block notification = nil;
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                                                                    object:context
                                                                     queue:nil
                                                                usingBlock:^(NSNotification *note) {
                                                                    notification = note;
                                                                }];
    
    // Setup client
    
    self.client = [[TestClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://test/v1/"]
                                 managedObjectContext:context];
    
    // Setup HTTP stub
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        NSString * path = OHPathForFileInBundle(@"models.json", nil);
        return [OHHTTPStubsResponse responseWithFileAtPath:path
                                                statusCode:200
                                                   headers:@{@"Content-Type": @"application/json"}];
    }];
    
    // Get models
    
    OVCResponse * __block response = nil;
    NSError * __block error = nil;
    
    [self.client GET:@"models" parameters:nil completion:^(OVCResponse *r, NSError *e) {
        response = r;
        error = e;
    }];
    
    TGRAssertEventually(response, @"should complete with a response");
    XCTAssertNil(error, @"should not return an error");
    XCTAssertTrue([response.result isKindOfClass:[NSArray class]], @"should return an array of test models");
    XCTAssertTrue([[response.result firstObject] isKindOfClass:[OVCTestModel class]], @"should return an array of test models");
    
    NSDictionary *userInfo = [notification userInfo];
    NSSet *objects = userInfo[NSInsertedObjectsKey];
    
    XCTAssertEqual(2U, [objects count], @"should insert two objects");
    
    for (NSManagedObject *object in objects) {
        XCTAssertEqualObjects(@"TestModel", [[object entity] name], @"should insert TestModel objects");
    }
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

@end
