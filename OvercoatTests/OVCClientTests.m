//
//  OVCClientTests.m
//  Overcoat
//
//  Created by guille on 09/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "OVCClient.h"
#import "OVCRequestOperation.h"
#import "TestModel.h"

@interface AFHTTPClient ()
@property (readwrite, nonatomic, strong) NSMutableArray *registeredHTTPOperationClassNames;
@end

static const signed short kOperationExecutingState = 2;
static const signed short kOperationFinishedState = 3;

@interface AFURLConnectionOperation ()
@property (readwrite, nonatomic, assign) signed short state;
@end

@interface AFHTTPRequestOperation ()
@property (copy, nonatomic, readwrite) NSString *responseString;
@property (strong, nonatomic, readwrite) NSData *responseData;
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
    BOOL operationClassRegistered = [self.client.registeredHTTPOperationClassNames containsObject:NSStringFromClass([OVCRequestOperation class])];
    STAssertTrue(operationClassRegistered, nil);
    STAssertEqualObjects([self.client defaultValueForHeader:@"Accept"], @"application/json", nil);
}

- (void)testExecuteQueryWithInvalidQuery {
    STAssertThrows([self.client executeQuery:nil completionBlock:nil], nil);
}

- (void)testExecuteQueryWithoutCompletionBlock {
    STAssertNoThrow([self.client executeQuery:[OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/"] completionBlock:nil], nil);
}

- (void)testRequestWithQueryPassingNil {
    STAssertThrows([self.client requestWithQuery:nil], nil);
}

- (void)testExecuteQuery {
    OVCTransformBlock block = ^id (id object){
        return nil;
    };

    id mockedQuery = [OCMockObject mockForClass:[OVCQuery class]];
    [[[mockedQuery expect] andReturnValue:OCMOCK_VALUE(block)] transformBlock];

    id mockedClient = [OCMockObject partialMockForObject:self.client];
    id mockedRequest = [OCMockObject mockForClass:[NSMutableURLRequest class]];
    [[[mockedClient expect] andReturn:mockedRequest] requestWithQuery:mockedQuery];

    id mockedOperation = [OCMockObject mockForClass:[OVCRequestOperation class]];
    [[mockedOperation expect] setTransformBlock:block];
    [[[mockedClient expect] andReturn:mockedOperation] HTTPRequestOperationWithRequest:mockedRequest success:nil failure:nil];
    [[mockedClient expect] enqueueHTTPRequestOperation:mockedOperation];

    [mockedClient executeQuery:mockedQuery completionBlock:nil];

    [mockedQuery verify];
    [mockedOperation verify];
    [mockedClient verify];
}

- (void)testExecuteQueryCompletion {
    [self.client.operationQueue setSuspended:YES];

    __block OVCRequestOperation *blockOperation = nil;
    __block TestModel *blockModel = nil;
    __block NSError *blockError = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/" modelClass:[TestModel class]];
    OVCRequestOperation *operation = [self.client executeQuery:query completionBlock:^(OVCRequestOperation *op, id object, NSError *error) {
        blockOperation = op;
        blockModel = object;
        blockError = error;
        dispatch_semaphore_signal(semaphore);
    }];

    NSString *responseString = @"{\"first_name\" : \"Bruce\", \"last_name\" : \"Wayne\"}";
    operation.responseString = responseString;
    operation.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

    // Call NSOperation completion block
    operation.state = kOperationExecutingState;
    operation.state = kOperationFinishedState;
    operation.completionBlock();

    // Need to wait for the semaphore to be signaled as the transform block is executed in a private queue
    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    STAssertEqualObjects(operation, blockOperation, nil);

    TestModel *expectedModel = [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"];
    STAssertEqualObjects(blockModel, expectedModel, nil);

    STAssertNil(blockError, nil);
}

- (void)testExecuteQueryCompletionWithError {
    [self.client.operationQueue setSuspended:YES];

    __block OVCRequestOperation *blockOperation = nil;
    __block TestModel *blockModel = nil;
    __block NSError *blockError = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/" modelClass:[TestModel class]];
    OVCRequestOperation *operation = [self.client executeQuery:query completionBlock:^(OVCRequestOperation *op, id object, NSError *error) {
        blockOperation = op;
        blockModel = object;
        blockError = error;
        dispatch_semaphore_signal(semaphore);
    }];

    NSString *responseString = @"<!DOCTYPE html><html lang=\"en\"></html>";
    operation.responseString = responseString;
    operation.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

    // Call NSOperation completion block
    operation.state = kOperationExecutingState;
    operation.state = kOperationFinishedState;
    operation.completionBlock();

    // Need to wait for the semaphore to be signaled as the transform block is executed in a private queue
    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    STAssertEqualObjects(operation, blockOperation, nil);

    STAssertNil(blockModel, nil);
    STAssertNotNil(blockError, nil);
    STAssertEqualObjects(operation.error, blockError, nil);
}

- (void)testThatRequestWithQueryCallsMultipartFormRequestWithMethod {
    id mockedClient = [OCMockObject partialMockForObject:self.client];

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/" parameters:@{@"foo" : @"bar"}];
    [query addMultipartData:[@"some data" dataUsingEncoding:NSUTF8StringEncoding] withName:@"name" type:@"text/plain" filename:@"file.txt"];

    [[mockedClient expect] multipartFormRequestWithMethod:@"GET" path:query.path parameters:query.parameters constructingBodyWithBlock:OCMOCK_ANY];

    [mockedClient requestWithQuery:query];
    [mockedClient verify];
}

- (void)testThatRequestWithQueryCallsRequestWithMethod {
    id mockedClient = [OCMockObject partialMockForObject:self.client];

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/" parameters:@{@"foo" : @"bar"}];

    [[mockedClient expect] requestWithMethod:@"GET" path:query.path parameters:query.parameters];

    [mockedClient requestWithQuery:query];
    [mockedClient verify];
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
