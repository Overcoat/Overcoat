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

#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "OVCClient.h"

// `OVCClient` subclass that authenticates API requests using an ACAccount
// object on supported social networking services.
@interface OVCSocialClient : OVCClient

// Account information used to sign requests.
@property (strong, nonatomic, readonly) ACAccount *account;

// The social networking service type. If `account` is set this property is ignored.
@property (copy, nonatomic, readonly) NSString *serviceType;

// Initializes the receiver with the specified account and base URL.
//
// account - The account information that will be used to sign requests.
// url     - The base URL for the HTTP client. This argument must not be `nil`.
- (id)initWithAccount:(ACAccount *)account baseURL:(NSURL *)url;

// Initializes the receiver with the specified serviceType and base URL.
//
// serviceType - The social networking service type.
// url         - The base URL for the HTTP client. This argument must not be `nil`.
- (id)initWithServiceType:(NSString *)serviceType baseURL:(NSURL *)url;

@end
