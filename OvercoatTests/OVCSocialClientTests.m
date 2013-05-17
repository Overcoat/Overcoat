//
//  OVCSocialClientTests.m
//  Overcoat
//
//  Created by guille on 16/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import <Accounts/Accounts.h>

#import "OVCSocialClient.h"
#import "OVCQuery.h"

@interface OVCSocialClient ()
- (SLRequest *)socialRequestWithQuery:(OVCQuery *)query;
- (NSMutableURLRequest *)preparedURLRequestWithSocialRequest:(SLRequest *)request query:(OVCQuery *)query;
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

- (void)testRequestWithQueryRequiresQuery {
    STAssertThrows([self.socialClient requestWithQuery:nil], nil);
}

- (void)testRequestWithQueryCallsSocialRequestWithQuery {
    id mockClient = [OCMockObject partialMockForObject:self.socialClient];

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/"];
    [[mockClient expect] socialRequestWithQuery:query];

    [mockClient requestWithQuery:query];
    [mockClient verify];
}

- (void)testRequestWithQueryCallsPreparedURLRequestWithSocialRequest {
    id mockClient = [OCMockObject partialMockForObject:self.socialClient];

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/"];
    id socialRequest = [OCMockObject mockForClass:[SLRequest class]];
    [[[mockClient stub] andReturn:socialRequest] socialRequestWithQuery:query];

    [[mockClient expect] preparedURLRequestWithSocialRequest:socialRequest query:query];

    [mockClient requestWithQuery:query];
    [mockClient verify];
}

- (void)testSocialRequestWithQueryRequiresServiceType {
    STAssertThrows([self.socialClient socialRequestWithQuery:[OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/"]], nil);
}

- (void)testSocialRequestWithQueryUsingAccountType {
    self.socialClient.serviceType = SLServiceTypeFacebook; // Facebook service

    id accountType = [OCMockObject mockForClass:[ACAccountType class]];
    [[[accountType stub] andReturn:ACAccountTypeIdentifierTwitter] identifier];

    id account = [OCMockObject mockForClass:[ACAccount class]];
    [[[account stub] andReturn:accountType] accountType];

    self.socialClient.account = account; // Twitter account

    id request = [OCMockObject mockForClass:[SLRequest class]];

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodPost path:@"/path" parameters:@{@"foo" : @"bar"}];
    [[request expect] requestForServiceType:SLServiceTypeTwitter // <-- Overridden by account
                              requestMethod:SLRequestMethodPOST
                                        URL:[NSURL URLWithString:query.path relativeToURL:self.socialClient.baseURL]
                                 parameters:query.parameters];
    [[[request stub] andReturn:nil] requestForServiceType:OCMOCK_ANY requestMethod:SLRequestMethodPOST URL:OCMOCK_ANY parameters:OCMOCK_ANY];

    [self.socialClient requestWithQuery:query];

    [request verify];
}

- (void)testSocialRequestWithQueryUsingServiceType {
    self.socialClient.serviceType = SLServiceTypeFacebook;

    id request = [OCMockObject mockForClass:[SLRequest class]];

    OVCQuery *query = [OVCQuery queryWithMethod:OVCQueryMethodPost path:@"/path" parameters:@{@"foo" : @"bar"}];
    [[request expect] requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodPOST
                                        URL:[NSURL URLWithString:query.path relativeToURL:self.socialClient.baseURL]
                                 parameters:query.parameters];
    [[[request stub] andReturn:nil] requestForServiceType:OCMOCK_ANY requestMethod:SLRequestMethodPOST URL:OCMOCK_ANY parameters:OCMOCK_ANY];

    [self.socialClient requestWithQuery:query];

    [request verify];
}

- (void)testThatPreparedURLRequestWithSocialRequestUsesAccount {
    id accountType = [OCMockObject mockForClass:[ACAccountType class]];
    [[[accountType stub] andReturn:ACAccountTypeIdentifierTwitter] identifier];

    id account = [OCMockObject mockForClass:[ACAccount class]];
    [[[account stub] andReturn:accountType] accountType];

    self.socialClient.account = account;
    id request = [OCMockObject niceMockForClass:[SLRequest class]];
    [[request expect] setAccount:account];

    [self.socialClient preparedURLRequestWithSocialRequest:request query:nil];
    [request verify];
}

- (void)testThatPreparedURLRequestWithSocialRequestAddsMultipartParts {
    OVCQuery *query = [[OVCQuery alloc] init];
    [query addMultipartData:[@"some data" dataUsingEncoding:NSUTF8StringEncoding] withName:@"name" type:@"type" filename:@"filename"];

    id request = [OCMockObject niceMockForClass:[SLRequest class]];
    [[request expect] addMultipartData:[@"some data" dataUsingEncoding:NSUTF8StringEncoding] withName:@"name" type:@"type" filename:@"filename"];

    [self.socialClient preparedURLRequestWithSocialRequest:request query:query];
    [request verify];
}

- (void)testThatPreparedURLRequestWithSocialRequestCallsPreparedURLRequest {
    id request = [OCMockObject niceMockForClass:[SLRequest class]];
    [[request expect] preparedURLRequest];

    [self.socialClient preparedURLRequestWithSocialRequest:request query:nil];
    [request verify];
}

@end
