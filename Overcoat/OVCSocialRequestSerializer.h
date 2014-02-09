// OVCSocialRequestSerializer.h
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

#import <AFNetworking/AFNetworking.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

/**
 Serializes requests for supported Social networking services and signs them using the user's social media accounts.
 */
@interface OVCSocialRequestSerializer : AFHTTPRequestSerializer

/**
 Account information used to sign requests.
 */
@property (strong, nonatomic) ACAccount *account;

/**
 The social networking service type. If `account` is set this property is ignored.
 */
@property (copy, nonatomic) NSString *serviceType;

/**
 Creates and returns a Social request serializer with the specified account.
 
 @param account The account information that will be used to sign requests.
 */
+ (instancetype)serializerWithAccount:(ACAccount *)account;

/**
 Creates and returns a Social request serializer with the specified service type.
 
 @param serviceType The social networking service type.
 */
+ (instancetype)serializerWithServiceType:(NSString *)serviceType;

@end
