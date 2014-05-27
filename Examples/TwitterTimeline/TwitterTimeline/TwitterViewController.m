// TwitterViewController.m
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

#import "TwitterViewController.h"

#import "ACAccountStore+Twitter.h"

#import <Accounts/Accounts.h>
#import <PromiseKit/PromiseKit.h>

@interface TwitterViewController ()

@property (strong, nonatomic) ACAccount *account;

@end

@implementation TwitterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.account) {
        [[ACAccountStore sharedAccountStore] promiseForTwitterAccounts].then(^(NSArray *accounts) {
            if ([accounts count]) {
                self.account = [accounts firstObject];
                self.title = self.account.accountDescription;
            } else {
                NSLog(@"There are no Twitter accounts...");
            }
        }).catch(^(NSError *error) {
            NSLog(@"Error accessing Twitter accounts: %@", error);
        });
    }
}

@end
