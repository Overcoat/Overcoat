// ACAccountStore+Twitter.m
//
// Copyright (c) 2014 Guillermo Gonzalez
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

#import "ACAccountStore+Twitter.h"
#import <PromiseKit/PromiseKit.h>

@implementation ACAccountStore (Twitter)

+ (ACAccountStore *)sharedAccountStore {
    static dispatch_once_t onceToken;
    static ACAccountStore *accountStore;
    
    dispatch_once(&onceToken, ^{
        accountStore = [[ACAccountStore alloc] init];
    });
    
    return accountStore;
}

- (AnyPromise *)promiseForTwitterAccounts {
    ACAccountType *type = [self accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([type accessGranted]) {
        NSArray *accounts = [self accountsWithAccountType:type];
        return [AnyPromise promiseWithValue:accounts];
    }

    return [self requestAccessToAccountsWithType:type options:nil];
}

@end
