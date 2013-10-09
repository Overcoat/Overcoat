// OVCSocialRequestSerializer.m
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

#import "OVCSocialRequestSerializer.h"

@implementation OVCSocialRequestSerializer

+ (instancetype)serializerWithAccount:(ACAccount *)account {
    OVCSocialRequestSerializer *serializer = [[self alloc] init];
    serializer.account = account;
    
    return serializer;
}

+ (instancetype)serializerWithServiceType:(NSString *)serviceType {
    OVCSocialRequestSerializer *serializer = [[self alloc] init];
    serializer.serviceType = serviceType;
    
    return serializer;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(NSDictionary *)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSString *serviceType = [self requestServiceType];
    NSAssert(serviceType, @"*** No service type found!");
    
    SLRequestMethod method = [self.class socialRequestMethodForMethod:request.HTTPMethod];
    SLRequest *socialRequest = [SLRequest requestForServiceType:serviceType
                                                  requestMethod:method
                                                            URL:request.URL
                                                     parameters:parameters];
    socialRequest.account = self.account;
    
    NSMutableURLRequest *mutableRequest = [socialRequest.preparedURLRequest mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        [mutableRequest setValue:value forHTTPHeaderField:field];
    }];
    
    return mutableRequest;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        NSString *accountIdentifier = [aDecoder decodeObjectForKey:@"accountIdentifier"];
        if (accountIdentifier) {
            self.account = [self.class.defaultAccountStore accountWithIdentifier:accountIdentifier];
        }
        
        self.serviceType = [aDecoder decodeObjectForKey:@"serviceType"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.account.identifier forKey:@"accountIdentifier"];
    [aCoder encodeObject:self.serviceType forKey:@"serviceType"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    OVCSocialRequestSerializer *serializer = [super copyWithZone:zone];
    serializer.account = self.account;
    serializer.serviceType = self.serviceType;
    
    return serializer;
}

#pragma mark - Private methods

- (NSString *)requestServiceType {
    if (self.account != nil) {
        return [self.class serviceTypeForAccountTypeIdentifier:self.account.accountType.identifier];
    }
    
    return self.serviceType;
}

+ (NSString *)serviceTypeForAccountTypeIdentifier:(NSString *)accountTypeIdentifier {
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

+ (SLRequestMethod)socialRequestMethodForMethod:(NSString *)method {
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

+ (ACAccountStore *)defaultAccountStore {
    static dispatch_once_t onceToken;
    static ACAccountStore *accountStore;
    
    dispatch_once(&onceToken, ^{
        accountStore = [[ACAccountStore alloc] init];
    });
    
    return accountStore;
}

@end
