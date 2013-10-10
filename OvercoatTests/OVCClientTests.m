//
//  OVCClientTests.m
//  Overcoat
//
//  Created by guille on 09/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import "TestModel.h"

@interface OVCClientTests : OVCTestCase

@property (strong, nonatomic) OVCClient *client;

@end

@implementation OVCClientTests

- (void)setUp {
    [super setUp];

    self.client = [[OVCClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://test"]];
}

- (void)tearDown {
    self.client = nil;
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)testInitWithAccount {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
    
    self.client = [OVCClient clientWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]
                                       account:account];
    
    STAssertEqualObjects(self.client.baseURL, [NSURL URLWithString:@"https://api.twitter.com/1.1/"], @"should initialize baseURL");
    
    OVCSocialRequestSerializer *requestSerializer = (OVCSocialRequestSerializer *)self.client.requestSerializer;
    STAssertTrue([requestSerializer isKindOfClass:OVCSocialRequestSerializer.class], @"requestSerializer should be a social request serializer");
    STAssertEqualObjects(requestSerializer.account, account, @"should initialize the serializer's account");
}

- (void)testGET {
    NSDictionary *parameters = @{@"foo" : @"bar"};
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    id requestSerializer = [self autoVerifiedMockForClass:AFHTTPRequestSerializer.class];
    [[[requestSerializer expect] andReturn:request] requestWithMethod:@"GET"
                                                            URLString:@"http://test/search"
                                                           parameters:parameters];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] init];
    id operationQueue = [self autoVerifiedMockForClass:NSOperationQueue.class];
    [[operationQueue expect] addOperation:requestOperation];
    
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };
    
    id mockClient = [self autoVerifiedPartialMockForObject:self.client];
    
    [[[mockClient stub] andReturn:requestSerializer] requestSerializer];
    [[[mockClient stub] andReturn:operationQueue] operationQueue];
    [[[mockClient expect] andReturn:requestOperation] HTTPRequestOperationWithRequest:request
                                                                          resultClass:TestModel.class
                                                                        resultKeyPath:@"data.object"
                                                                           completion:block];
    
    AFHTTPRequestOperation *operation = [self.client GET:@"search"
                                              parameters:parameters
                                             resultClass:TestModel.class
                                           resultKeyPath:@"data.object"
                                              completion:block];
    STAssertEqualObjects(operation, requestOperation, @"should return the operation");
}

- (void)testPOST {
    NSDictionary *parameters = @{@"foo" : @"bar"};
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    id requestSerializer = [self autoVerifiedMockForClass:AFHTTPRequestSerializer.class];
    [[[requestSerializer expect] andReturn:request] requestWithMethod:@"POST"
                                                            URLString:@"http://test/create"
                                                           parameters:parameters];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] init];
    id operationQueue = [self autoVerifiedMockForClass:NSOperationQueue.class];
    [[operationQueue expect] addOperation:requestOperation];
    
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };
    
    id mockClient = [self autoVerifiedPartialMockForObject:self.client];
    
    [[[mockClient stub] andReturn:requestSerializer] requestSerializer];
    [[[mockClient stub] andReturn:operationQueue] operationQueue];
    [[[mockClient expect] andReturn:requestOperation] HTTPRequestOperationWithRequest:request
                                                                          resultClass:TestModel.class
                                                                        resultKeyPath:@"data.object"
                                                                           completion:block];
    
    AFHTTPRequestOperation *operation = [self.client POST:@"create"
                                               parameters:parameters
                                              resultClass:TestModel.class
                                            resultKeyPath:@"data.object"
                                               completion:block];
    STAssertEqualObjects(operation, requestOperation, @"should return the operation");
}

- (void)testMultipartPOST {
    NSDictionary *parameters = @{@"foo" : @"bar"};
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    void (^bodyBlock)(id <AFMultipartFormData>) = ^(id <AFMultipartFormData> formData) {
    };
    
    id requestSerializer = [self autoVerifiedMockForClass:AFHTTPRequestSerializer.class];
    [[[requestSerializer expect] andReturn:request] multipartFormRequestWithMethod:@"POST"
                                                                         URLString:@"http://test/create"
                                                                        parameters:parameters
                                                         constructingBodyWithBlock:bodyBlock];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] init];
    id operationQueue = [self autoVerifiedMockForClass:NSOperationQueue.class];
    [[operationQueue expect] addOperation:requestOperation];
    
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };
    
    id mockClient = [self autoVerifiedPartialMockForObject:self.client];
    
    [[[mockClient stub] andReturn:requestSerializer] requestSerializer];
    [[[mockClient stub] andReturn:operationQueue] operationQueue];
    [[[mockClient expect] andReturn:requestOperation] HTTPRequestOperationWithRequest:request
                                                                          resultClass:TestModel.class
                                                                        resultKeyPath:@"data.object"
                                                                           completion:block];
    
    AFHTTPRequestOperation *operation = [self.client POST:@"create"
                                               parameters:parameters
                                              resultClass:TestModel.class
                                            resultKeyPath:@"data.object"
                                constructingBodyWithBlock:bodyBlock
                                               completion:block];
    STAssertEqualObjects(operation, requestOperation, @"should return the operation");
}

- (void)testPUT {
    NSDictionary *parameters = @{@"foo" : @"bar"};
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    id requestSerializer = [self autoVerifiedMockForClass:AFHTTPRequestSerializer.class];
    [[[requestSerializer expect] andReturn:request] requestWithMethod:@"PUT"
                                                            URLString:@"http://test/update"
                                                           parameters:parameters];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] init];
    id operationQueue = [self autoVerifiedMockForClass:NSOperationQueue.class];
    [[operationQueue expect] addOperation:requestOperation];
    
    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
    };
    
    id mockClient = [self autoVerifiedPartialMockForObject:self.client];
    
    [[[mockClient stub] andReturn:requestSerializer] requestSerializer];
    [[[mockClient stub] andReturn:operationQueue] operationQueue];
    [[[mockClient expect] andReturn:requestOperation] HTTPRequestOperationWithRequest:request
                                                                          resultClass:TestModel.class
                                                                        resultKeyPath:@"data.object"
                                                                           completion:block];
    
    AFHTTPRequestOperation *operation = [self.client PUT:@"update"
                                              parameters:parameters
                                             resultClass:TestModel.class
                                           resultKeyPath:@"data.object"
                                              completion:block];
    STAssertEqualObjects(operation, requestOperation, @"should return the operation");
}

- (void)testHTTPRequestOperationCompletion {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"testResponse" withExtension:@"json"];
        return [OHHTTPStubsResponse responseWithFileURL:fileURL contentType:@"application/json" responseTime:0];
    }];
    
    AFHTTPRequestOperation * __block blockOperation = nil;
    TestModel * __block blockObject = nil;
    NSError * __block blockError = nil;

    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        blockOperation = operation;
        blockObject = responseObject;
        blockError = error;
    };

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test"]];
    AFHTTPRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request
                                                                         resultClass:TestModel.class
                                                                       resultKeyPath:@"data.object"
                                                                          completion:block];
    [operation start];

    TGRAssertEventually(blockObject != nil, @"should return an object");
    
    STAssertEqualObjects(operation, blockOperation, @"should pass the operation in the completion block");
    STAssertTrue([blockObject isKindOfClass:TestModel.class], @"should return a TestModel object");
    STAssertNil(blockError, @"should return no error");
}

- (void)testHTTPRequestOperationCompletionWithError {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
        return [OHHTTPStubsResponse responseWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                          code:NSURLErrorBadServerResponse
                                                                      userInfo:nil]];
    }];
    
    NSError * __block blockError = nil;

    void (^block)(AFHTTPRequestOperation *, id, NSError *) = ^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        blockError = error;
    };

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test"]];
    AFHTTPRequestOperation *operation = [self.client HTTPRequestOperationWithRequest:request
                                                                         resultClass:TestModel.class
                                                                       resultKeyPath:@"data.object"
                                                                          completion:block];
    [operation start];

    TGRAssertEventually(blockError != nil, @"should return an error");

    STAssertEqualObjects(blockError.domain, NSURLErrorDomain, nil);
    STAssertEquals(blockError.code, (NSInteger)NSURLErrorBadServerResponse, nil);
}

@end
