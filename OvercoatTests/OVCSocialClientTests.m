//
//  OVCSocialClientTests.m
//  Overcoat
//
//  Created by guille on 16/05/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

@interface OVCSocialClientTests : SenTestCase

@end

@implementation OVCSocialClientTests

- (void)testInitWithAccount {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
    
    OVCSocialClient *client = [[OVCSocialClient alloc] initWithAccount:account
                                                               baseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]];
    STAssertEqualObjects(client.baseURL, [NSURL URLWithString:@"https://api.twitter.com/1.1/"], @"should initialize baseURL");
    STAssertEqualObjects(client.account, account, @"should initialize account");
}

- (void)testInitWithServiceType {
    OVCSocialClient *client = [[OVCSocialClient alloc] initWithServiceType:SLServiceTypeTwitter
                                                                   baseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/"]];
    STAssertEqualObjects(client.baseURL, [NSURL URLWithString:@"https://api.twitter.com/1.1/"], @"should initialize baseURL");
    STAssertEqualObjects(client.serviceType, SLServiceTypeTwitter, @"should initialize serviceType");
}

@end
