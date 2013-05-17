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

#if ((__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0) || (__MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_10_8))

#import <Social/Social.h>
#import "OVCClient.h"

// OVCClient subclass that allows executing queries on supported social networking services.
@interface OVCSocialClient : OVCClient

// Account information used to authenticate every request.
@property (strong, nonatomic) ACAccount *account;

// The social networking service type. If the account property is set this value is not used.
@property (copy, nonatomic) NSString *serviceType;

@end

#else
#warning OVCSocialClient is available for iOS 6 / OS X 10.8 or higher.
#endif
