//
//  OVCRequestOperationTests.m
//  Overcoat
//
//  Created by guille on 14/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import "TestModel.h"

@interface OVCRequestOperationTests : SenTestCase

@property (copy, nonatomic) NSURLRequest *urlRequest;
@property (strong, nonatomic) id requestHandler;

- (BOOL)waitForSemaphore:(dispatch_semaphore_t)semaphore timeout:(NSTimeInterval)timeout;

@end

@implementation OVCRequestOperationTests

- (void)setUp {
    [super setUp];

    self.urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.example.com"]];
    
    self.requestHandler = [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"testResponse" withExtension:@"json"];
        return [OHHTTPStubsResponse responseWithFileURL:fileURL contentType:@"application/json" responseTime:0];
    }];
}

- (void)tearDown {
    [OHHTTPStubs removeRequestHandler:self.requestHandler];
    self.requestHandler = nil;
    self.urlRequest = nil;

    [super tearDown];
}

- (void)testResponseObject {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] initWithRequest:self.urlRequest
                                                                             resultClass:TestModel.class
                                                                           resultKeyPath:@"data.object"];

    TestModel *__block model = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        model = responseObject;
        dispatch_semaphore_signal(semaphore);
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];

    [requestOperation start];

    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    TestModel *expectedModel = [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"];
    STAssertEqualObjects(model, expectedModel, nil);
}

- (void)testResponseObjectWithArray {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] initWithRequest:self.urlRequest
                                                                             resultClass:TestModel.class
                                                                           resultKeyPath:@"data.objects"];

    NSArray * __block models = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        models = responseObject;
        dispatch_semaphore_signal(semaphore);
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];

    [requestOperation start];

    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    NSArray *expectedModels = @[
            [TestModel testModelWithFirstName:@"Tony" lastName:@"Stark"],
            [TestModel testModelWithFirstName:@"Bruce" lastName:@"Banner"],
    ];
    STAssertEqualObjects(models, expectedModels, nil);
}

- (void)testResponseObjectWithoutValueTransformer {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] initWithRequest:self.urlRequest];

    NSDictionary * __block dictionary = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dictionary = responseObject;
        dispatch_semaphore_signal(semaphore);
    }                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];

    [requestOperation start];

    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"testResponse" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *testResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

    STAssertEqualObjects(dictionary, testResponse, nil);
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
