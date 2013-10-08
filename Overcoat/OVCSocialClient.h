// OVCSocialClient.h
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

#import <Social/Social.h>
#import "OVCClient.h"

// OVCClient subclass that allows executing queries on supported social networking services.
@interface OVCSocialClient : OVCClient

// Account information used to authenticate every request.
@property (strong, nonatomic, readonly) ACAccount *account;

// The social networking service type. If the account property is set this value is not used.
@property (copy, nonatomic, readonly) NSString *serviceType;

// Initializes an `OVCSocialClient` object with the specified account and base URL.
//
// account - The account information used to authenticate every request.
// url     - The base URL for the HTTP client. This argument must not be `nil`.
- (id)initWithAccount:(ACAccount *)account baseURL:(NSURL *)url;

// Initializes an `OVCSocialClient` object with the specified serviceType and base URL.
//
// serviceType - The social networking service type. Possible values are SLServiceTypeFacebook,
//               SLServiceTypeTwitter and SLServiceTypeSinaWeibo.
// url         - The base URL for the HTTP client. This argument must not be `nil`.
- (id)initWithServiceType:(NSString *)serviceType baseURL:(NSURL *)url;

// Creates an OAuth-compatible `NSMutableURLRequest` signed with the user's account.
//
// method     - The HTTP method for the request. A `PUT` method will be converted to `POST`. This parameter must
//              not be `PATCH` or `HEAD`, or `nil`.
// path       - The path to be appended to the HTTP client's base URL and used as the request URL.
// parameters - The parameters for the HTTP request.
// parts      - An optional array of OVCMultipartPart objects to construct a multipart POST body.
- (NSMutableURLRequest *)socialRequestWithMethod:(NSString *)method
                                            path:(NSString *)path
                                      parameters:(NSDictionary *)parameters
                                           parts:(NSArray *)parts;

@end
