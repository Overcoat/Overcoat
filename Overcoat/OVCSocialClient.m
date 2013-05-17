// OVCSocialClient.m
// 
// Copyright (c) 2013 Guillermo Gonzalez
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if ((__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0) || (__MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_8))

#import <Accounts/Accounts.h>
#import "OVCSocialClient.h"
#import "OVCQuery.h"
#import "OVCMultipartPart.h"

static NSString *OVCServiceTypeForAccountTypeIdentifier(NSString *accountTypeIdentifier) {
    static dispatch_once_t onceToken;
    static NSDictionary *serviceTypes;

    dispatch_once(&onceToken, ^{
        serviceTypes = @{
                ACAccountTypeIdentifierTwitter : SLServiceTypeTwitter,
                ACAccountTypeIdentifierFacebook : SLServiceTypeFacebook,
                ACAccountTypeIdentifierSinaWeibo : SLServiceTypeSinaWeibo
        };
    });

    return serviceTypes[accountTypeIdentifier];
}

static SLRequestMethod OVCSocialRequestMethod(OVCQueryMethod method) {
    static dispatch_once_t onceToken;
    static NSDictionary *methods;

    dispatch_once(&onceToken, ^{
        methods = @{
                @(OVCQueryMethodGet) : @(SLRequestMethodGET),
                @(OVCQueryMethodPost) : @(SLRequestMethodPOST),
                @(OVCQueryMethodPut) : @(SLRequestMethodPOST),
                @(OVCQueryMethodDelete) : @(SLRequestMethodDELETE)
        };
    });

    return (SLRequestMethod) [methods[@(method)] integerValue];
}

@interface OVCSocialClient ()

- (SLRequest *)socialRequestWithQuery:(OVCQuery *)query;

- (NSMutableURLRequest *)preparedURLRequestWithSocialRequest:(SLRequest *)request query:(OVCQuery *)query;

@end

@implementation OVCSocialClient

- (NSMutableURLRequest *)requestWithQuery:(OVCQuery *)query {
    NSParameterAssert(query);

    SLRequest *request = [self socialRequestWithQuery:query];
    return [self preparedURLRequestWithSocialRequest:request query:query];
}

#pragma mark - Private methods

- (SLRequest *)socialRequestWithQuery:(OVCQuery *)query {
    NSString *serviceType = self.account ? OVCServiceTypeForAccountTypeIdentifier(self.account.accountType.identifier) : self.serviceType;
    NSAssert(serviceType, @"*** No service type found!");

    return [SLRequest requestForServiceType:serviceType
                              requestMethod:OVCSocialRequestMethod(query.method)
                                        URL:[NSURL URLWithString:query.path relativeToURL:self.baseURL]
                                 parameters:query.parameters];
}

- (NSMutableURLRequest *)preparedURLRequestWithSocialRequest:(SLRequest *)request query:(OVCQuery *)query {
    request.account = self.account;

    if ([query.parts count]) {
        for (OVCMultipartPart *part in query.parts) {
            [request addMultipartData:part.data withName:part.name type:part.type filename:part.filename];
        }
    }

    return [[request preparedURLRequest] mutableCopy];
}

@end

#endif

