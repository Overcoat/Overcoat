//
//  OVCRequestOperationTests.m
//  Overcoat
//
//  Created by guille on 14/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <Overcoat/Overcoat.h>

#import "TestModel.h"

@interface AFURLConnectionOperation ()

- (void)finish;

@end

@interface AFHTTPRequestOperation ()

@property (copy, nonatomic, readwrite) NSString *responseString;
@property (strong, nonatomic, readwrite) NSData *responseData;

@end

@interface OVCRequestOperationTests : SenTestCase

- (BOOL)waitForSemaphore:(dispatch_semaphore_t)semaphore timeout:(NSTimeInterval)timeout;

@end

@implementation OVCRequestOperationTests

- (void)testResponseObject {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] init];
    requestOperation.transformBlock = [OVCQuery transformBlockWithModelClass:[TestModel class] objectKeyPath:nil];

    NSString *responseString = @"{\"first_name\" : \"Bruce\", \"last_name\" : \"Wayne\"}";
    requestOperation.responseString = responseString;
    requestOperation.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

    [requestOperation finish];

    TestModel *model = requestOperation.responseObject;
    TestModel *expectedModel = [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"];

    STAssertEqualObjects(model, expectedModel, nil);
}

- (void)testResponseObjectWithoutTransformBlock {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] init];

    NSString *responseString = @"[\"Tony\", \"Bruce\", \"Natasha\", \"Steve\"]";
    requestOperation.responseString = responseString;
    requestOperation.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

    [requestOperation finish];

    NSArray *expected = @[@"Tony", @"Bruce", @"Natasha", @"Steve"];

    STAssertEqualObjects(requestOperation.responseObject, expected, nil);
}

- (void)testCompletion {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] init];
    requestOperation.transformBlock = [OVCQuery transformBlockWithModelClass:[TestModel class] objectKeyPath:nil];

    NSString *responseString = @"{\"first_name\" : \"Bruce\", \"last_name\" : \"Wayne\"}";
    requestOperation.responseString = responseString;
    requestOperation.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

    [requestOperation finish];

    __block TestModel *model = nil;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        model = responseObject;
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];

    STAssertNotNil(requestOperation.completionBlock, nil);

    // Call NSOperation completion block
    requestOperation.completionBlock();

    // Need to wait for the semaphore to be signaled as the transform block is executed in a private queue
    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    TestModel *expectedModel = [TestModel testModelWithFirstName:@"Bruce" lastName:@"Wayne"];
    STAssertEqualObjects(model, expectedModel, nil);
}

- (void)testCompletionWithError {
    OVCRequestOperation *requestOperation = [[OVCRequestOperation alloc] init];
    requestOperation.transformBlock = [OVCQuery transformBlockWithModelClass:[TestModel class] objectKeyPath:nil];

    NSString *responseString = @"<!DOCTYPE html><html lang=\"en\"></html>";
    requestOperation.responseString = responseString;
    requestOperation.responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];

    [requestOperation finish];

    __block TestModel *model = nil;
    __block NSError *error = nil;

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        model = responseObject;
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *e) {
        error = e;
        dispatch_semaphore_signal(semaphore);
    }];

    STAssertNotNil(requestOperation.completionBlock, nil);

    // Call NSOperation completion block
    requestOperation.completionBlock();

    // Need to wait for the semaphore to be signaled as the transform block is executed in a private queue
    BOOL timeout = [self waitForSemaphore:semaphore timeout:5];
    STAssertFalse(timeout, @"Timeout waiting for processing queue");

    STAssertNil(model, nil);
    STAssertNotNil(error, nil);
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
