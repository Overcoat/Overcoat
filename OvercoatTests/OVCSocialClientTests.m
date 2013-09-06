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

- (void)testSocialRequestServiceTypeWithAccount {
    id accountType = [OCMockObject mockForClass:ACAccountType.class];
    [[[accountType stub] andReturn:ACAccountTypeIdentifierTwitter] identifier];
    id account = [OCMockObject mockForClass:ACAccount.class];
    [[[account stub] andReturn:accountType] accountType];

    self.socialClient.serviceType = SLServiceTypeFacebook; // Facebook service
    self.socialClient.account = account; // Twitter account

    // Service must be Twitter because the account is a Twitter account
    STAssertEqualObjects(self.socialClient.socialRequestServiceType, SLServiceTypeTwitter, nil);
}

- (void)testSocialRequestServiceTypeWithServiceType {
    self.socialClient.serviceType = SLServiceTypeFacebook;
    STAssertEqualObjects(self.socialClient.socialRequestServiceType, SLServiceTypeFacebook, nil);
}

@end
