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

#import "OVCSocialClient.h"
#import "OVCMultipartPart.h"

#import <Accounts/Accounts.h>

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

static SLRequestMethod OVCSocialRequestMethod(NSString *method) {
    static dispatch_once_t onceToken;
    static NSDictionary *methods;

    dispatch_once(&onceToken, ^{
        methods = @{
                @"GET" : @(SLRequestMethodGET),
                @"POST" : @(SLRequestMethodPOST),
                @"PUT" : @(SLRequestMethodPOST),
                @"DELETE" : @(SLRequestMethodDELETE)
        };
    });

    return (SLRequestMethod) [methods[method] integerValue];
}

@implementation OVCSocialClient

- (id)initWithAccount:(ACAccount *)account baseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        _account = account;
    }
    
    return self;
}

- (id)initWithServiceType:(NSString *)serviceType baseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        _serviceType = serviceType;
    }
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self socialRequestWithMethod:method path:path parameters:parameters parts:nil];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters parts:(NSArray *)parts {
    return [self socialRequestWithMethod:method path:path parameters:parameters parts:parts];
}

- (NSMutableURLRequest *)socialRequestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters parts:(NSArray *)parts {
    NSString *serviceType = [self socialRequestServiceType];
    NSAssert(serviceType, @"*** No service type found!");

    SLRequest *request = [SLRequest requestForServiceType:serviceType
                                            requestMethod:OVCSocialRequestMethod(method)
                                                      URL:[NSURL URLWithString:path relativeToURL:self.baseURL]
                                               parameters:parameters];
    request.account = self.account;

    for (OVCMultipartPart *part in parts) {
        [request addMultipartData:part.data withName:part.name type:part.type filename:part.filename];
    }

    return [[request preparedURLRequest] mutableCopy];
}

#pragma mark - Private methods

- (NSString *)socialRequestServiceType {
    return self.account ? OVCServiceTypeForAccountTypeIdentifier(self.account.accountType.identifier) : self.serviceType;
}

@end

#endif

