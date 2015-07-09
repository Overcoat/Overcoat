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

#pragma mark -

@interface OVCMultipartFormData : NSObject <AFMultipartFormData>

@property (strong, nonatomic, readonly) SLRequest *socialRequest;

- (id)initWithSocialRequest:(SLRequest *)request;

@end

#pragma mark -

@implementation OVCMultipartFormData

- (id)initWithSocialRequest:(SLRequest *)request {
    if (self = [super init]) {
        _socialRequest = request;
    }
    return self;
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * __autoreleasing *)error
{
    NSAssert(NO, @"OVCMultipartFormData: unsupported method");
    return NO;
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * __autoreleasing *)error
{
    NSAssert(NO, @"OVCMultipartFormData: unsupported method");
    return NO;
}

- (void)appendPartWithInputStream:(NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType
{
    NSAssert(NO, @"OVCMultipartFormData: unsupported method");
}

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType
{
    [self.socialRequest addMultipartData:data withName:name type:mimeType filename:fileName];
}

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name
{
    [self.socialRequest addMultipartData:data withName:name type:nil filename:nil];
}

- (void)appendPartWithHeaders:(NSDictionary *)headers
                         body:(NSData *)body
{
    NSAssert(NO, @"OVCMultipartFormData: unsupported method");
}

- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay
{
    NSAssert(NO, @"OVCMultipartFormData: unsupported method");
}

@end

#pragma mark -

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

#pragma mark - AFHTTPRequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     error:(NSError * __autoreleasing *)error
{
    SLRequest *socialRequest = [self socialRequestWithMethod:method
                                                   URLString:URLString
                                                  parameters:parameters];
    
    return [[socialRequest preparedURLRequest] mutableCopy];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                                  error:(NSError *__autoreleasing *)error
{
    SLRequest *socialRequest = [self socialRequestWithMethod:method
                                                   URLString:URLString
                                                  parameters:parameters];
    
    if (block) {
        OVCMultipartFormData *formData = [[OVCMultipartFormData alloc] initWithSocialRequest:socialRequest];
        block(formData);
    }
    
    return [[socialRequest preparedURLRequest] mutableCopy];
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

- (SLRequest *)socialRequestWithMethod:(NSString *)method
                             URLString:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
{
    NSParameterAssert(method);
    NSParameterAssert(URLString);
    
    NSString *serviceType = [self requestServiceType];
    NSAssert(serviceType, @"*** No service type found!");
    
    SLRequestMethod requestMethod = [self.class socialRequestMethodForMethod:method];
    SLRequest *socialRequest = [SLRequest requestForServiceType:serviceType
                                                  requestMethod:requestMethod
                                                            URL:[NSURL URLWithString:URLString]
                                                     parameters:parameters];
    socialRequest.account = self.account;
    
    return socialRequest;
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
