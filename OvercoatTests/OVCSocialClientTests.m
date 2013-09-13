//
//  OVCSocialClientTests.m
//  Overcoat
//
//  Created by guille on 16/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <Accounts/Accounts.h>

@interface OVCSocialClient ()

- (NSString *)socialRequestServiceType;

@end

@interface OVCSocialClientTests : SenTestCase

@property (strong, nonatomic) OVCSocialClient *socialClient;

@end

@implementation OVCSocialClientTests

- (void)setUp {
    [super setUp];

    self.socialClient = [[OVCSocialClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.example.com"]];
}

- (void)tearDown {
    [self.socialClient.operationQueue cancelAllOperations];
    self.socialClient = nil;

    [super tearDown];
}

- (void)testInitWithAccount {
    id accountType = [OCMockObject mockForClass:ACAccountType.class];
    [[[accountType stub] andReturn:ACAccountTypeIdentifierTwitter] identifier];
    id account = [OCMockObject mockForClass:ACAccount.class];
    [[[account stub] andReturn:accountType] accountType];
    
    OVCSocialClient *socialClient = [[OVCSocialClient alloc] initWithAccount:account
                                                                     baseURL:[NSURL URLWithString:@"http://www.example.com"]];
    STAssertEqualObjects(socialClient.account, account, nil);
    STAssertEqualObjects(socialClient.socialRequestServiceType, SLServiceTypeTwitter, nil);
}

- (void)testInitWithServiceType {
    OVCSocialClient *socialClient = [[OVCSocialClient alloc] initWithServiceType:SLServiceTypeFacebook
                                                                         baseURL:[NSURL URLWithString:@"http://www.example.com"]];
    STAssertEqualObjects(socialClient.serviceType, SLServiceTypeFacebook, nil);
    STAssertEqualObjects(socialClient.socialRequestServiceType, SLServiceTypeFacebook, nil);
}

- (void)testRequestWithMethod {
    id mockClient = [OCMockObject partialMockForObject:self.socialClient];

    NSString *method = @"GET";
    NSString *path = @"test";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };

    id mockRequest = [OCMockObject mockForClass:NSMutableURLRequest.class];
    [[[mockClient expect] andReturn:mockRequest] socialRequestWithMethod:method
                                                                    path:path
                                                              parameters:parameters
                                                                   parts:nil];

    NSMutableURLRequest *request = [self.socialClient requestWithMethod:method path:path parameters:parameters];
    [mockClient verify];
    STAssertEqualObjects(request, mockRequest, nil);
}

- (void)testMultipartFormRequestWithMethod {
    id mockClient = [OCMockObject partialMockForObject:self.socialClient];

    NSString *method = @"GET";
    NSString *path = @"test";
    NSDictionary *parameters = @{
            @"foo" : @"bar"
    };
    NSArray *parts = @[[OVCMultipartPart partWithData:[@"Some data" dataUsingEncoding:NSUTF8StringEncoding]
                                                 name:@"blob"
                                                 type:@"text/plain"
                                             filename:@"blob.txt"]];

    id mockRequest = [OCMockObject mockForClass:NSMutableURLRequest.class];
    [[[mockClient expect] andReturn:mockRequest] socialRequestWithMethod:method
                                                                    path:path
                                                              parameters:parameters
                                                                   parts:parts];

    NSMutableURLRequest *request = [self.socialClient multipartFormRequestWithMethod:method
                                                                                path:path
                                                                          parameters:parameters
                                                                               parts:parts];
    [mockClient verify];
    STAssertEqualObjects(request, mockRequest, nil);
}

@end
