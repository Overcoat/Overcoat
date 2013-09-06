//
//  OVCClientTests.m
//  Overcoat
//
//  Created by guille on 09/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import "TestModel.h"

@interface AFHTTPClient ()

@property (readwrite, nonatomic, strong) NSMutableArray *registeredHTTPOperationClassNames;

@end

@interface OVCClientTests : SenTestCase

@property (strong, nonatomic) OVCClient *client;

@end

@implementation OVCClientTests

- (void)setUp {
    [super setUp];

    self.client = [[OVCClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.example.com"]];
}

- (void)tearDown {
    [self.client.operationQueue cancelAllOperations];
    self.client = nil;

    [super tearDown];
}

- (void)testInit {
    BOOL operationClassRegistered = [self.client.registeredHTTPOperationClassNames containsObject:NSStringFromClass(OVCRequestOperation.class)];
    STAssertTrue(operationClassRegistered, nil);
    STAssertEqualObjects([self.client defaultValueForHeader:@"Accept"], @"application/json", nil);
}

- (void)testGET {
    id mockRequest = [OCMockObject mockForClass:NSURLRequest.class];
    id mockOperation = [OCMockObject mockForClass:OVCRequestOperation.class];
    id mockClient = [OCMockObject partialMockForObject:self.client];

    NSString *path = @"search";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };
    NSString *keyPath = @"data.objects";
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };

    [[[mockClient expect] andReturn:mockRequest] requestWithMethod:@"GET" path:path parameters:parameters];
    [[[mockClient expect] andReturn:mockOperation] HTTPRequestOperationWithRequest:mockRequest
                                                                       resultClass:TestModel.class
                                                                     resultKeyPath:keyPath
                                                                        completion:block];
    [[mockClient expect] enqueueHTTPRequestOperation:mockOperation];

    OVCRequestOperation *operation = [self.client GET:path
                                           parameters:parameters
                                          resultClass:TestModel.class
                                        resultKeyPath:keyPath
                                           completion:block];
    [mockClient verify];
    STAssertEqualObjects(operation, mockOperation, nil);
}

- (void)testPOST {
    id mockRequest = [OCMockObject mockForClass:NSURLRequest.class];
    id mockOperation = [OCMockObject mockForClass:OVCRequestOperation.class];
    id mockClient = [OCMockObject partialMockForObject:self.client];

    NSString *path = @"create";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };
    NSString *keyPath = @"data.object";
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };

    [[[mockClient expect] andReturn:mockRequest] requestWithMethod:@"POST" path:path parameters:parameters];
    [[[mockClient expect] andReturn:mockOperation] HTTPRequestOperationWithRequest:mockRequest
                                                                       resultClass:TestModel.class
                                                                     resultKeyPath:keyPath
                                                                        completion:block];
    [[mockClient expect] enqueueHTTPRequestOperation:mockOperation];

    OVCRequestOperation *operation = [self.client POST:path
                                            parameters:parameters
                                           resultClass:TestModel.class
                                         resultKeyPath:keyPath
                                            completion:block];
    [mockClient verify];
    STAssertEqualObjects(operation, mockOperation, nil);
}

- (void)testPUT {
    id mockRequest = [OCMockObject mockForClass:NSURLRequest.class];
    id mockOperation = [OCMockObject mockForClass:OVCRequestOperation.class];
    id mockClient = [OCMockObject partialMockForObject:self.client];

    NSString *path = @"update";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };
    NSString *keyPath = @"data.object";
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };

    [[[mockClient expect] andReturn:mockRequest] requestWithMethod:@"PUT" path:path parameters:parameters];
    [[[mockClient expect] andReturn:mockOperation] HTTPRequestOperationWithRequest:mockRequest
                                                                       resultClass:TestModel.class
                                                                     resultKeyPath:keyPath
                                                                        completion:block];
    [[mockClient expect] enqueueHTTPRequestOperation:mockOperation];

    OVCRequestOperation *operation = [self.client PUT:path
                                           parameters:parameters
                                          resultClass:TestModel.class
                                        resultKeyPath:keyPath
                                           completion:block];
    [mockClient verify];
    STAssertEqualObjects(operation, mockOperation, nil);
}

- (void)testHTTPRequestOperationCompletion {
    id requestHandler = [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"testResponse" withExtension:@"json"];
        return [OHHTTPStubsResponse responseWithFileURL:fileURL contentType:@"application/json" responseTime:0];
    }];

    AFHTTPRequestOperation * __block blockOperation = nil;
    TestModel * __block blockObject = nil;
    NSError * __block blockError = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        blockOperation = operation;
        blockObject = responseObject;
        blockError = error;
        dispatch_semaphore_signal(semaphore);
    };

    NSURLRequest *request = [self.client requestWithMethod:@"GET" path:@"test" parameters:nil];
    OVCRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request
                                                                      resultClass:TestModel.class
                                                                    resultKeyPath:@"data.object"
                                                                       completion:block];
    [operation start];

    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    STAssertNotNil(operation, nil);
    STAssertEqualObjects(operation, blockOperation, nil);
    STAssertEqualObjects([TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"], blockObject, nil);
    STAssertNil(blockError, nil);

    [OHHTTPStubs removeRequestHandler:requestHandler];
}

- (void)testHTTPRequestOperationCompletionWithError {
    id requestHandler = [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                          code:NSURLErrorBadServerResponse
                                                                      userInfo:nil]];
    }];

    AFHTTPRequestOperation * __block blockOperation = nil;
    TestModel * __block blockObject = nil;
    NSError * __block blockError = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        blockOperation = operation;
        blockObject = responseObject;
        blockError = error;
        dispatch_semaphore_signal(semaphore);
    };

    NSURLRequest *request = [self.client requestWithMethod:@"GET" path:@"test" parameters:nil];
    OVCRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request
                                                                      resultClass:TestModel.class
                                                                    resultKeyPath:@"data.object"
                                                                       completion:block];
    [operation start];

    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    STAssertNotNil(operation, nil);
    STAssertEqualObjects(operation, blockOperation, nil);
    STAssertNil(blockObject, nil);
    STAssertEqualObjects(blockError.domain, NSURLErrorDomain, nil);
    STAssertEquals(blockError.code, (NSInteger)NSURLErrorBadServerResponse, nil);

    [OHHTTPStubs removeRequestHandler:requestHandler];
}

- (void)testMultipartFormRequest {
    id mockClient = [OCMockObject partialMockForObject:self.client];

    NSString *method = @"GET";
    NSString *path = @"test";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };
    NSArray *parts = [NSArray array];

    id mockRequest = [OCMockObject mockForClass:NSMutableURLRequest.class];
    [[[mockClient expect] andReturn:mockRequest] multipartFormRequestWithMethod:method
                                                                           path:path
                                                                     parameters:parameters
                                                      constructingBodyWithBlock:OCMOCK_ANY];
    NSMutableURLRequest *request = [self.client multipartFormRequestWithMethod:method
                                                                          path:path
                                                                    parameters:parameters
                                                                         parts:parts];
    [mockClient verify];
    STAssertEqualObjects(request, mockRequest, nil);
}

- (BOOL)waitForSemaphore:(dispatch_semaphore_t)semaphore timeout:(NSTimeInterval)timeout {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeout];

    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:date];

        if ([date timeIntervalSinceNow] < 0.0) {
            return YES;
        }
    }

    return NO;
}

@end
