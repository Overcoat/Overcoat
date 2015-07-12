// OVCManagedHTTPRequestOperationManager.m
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

#import "OVCManagedHTTPSessionManager.h"
#import "OVCManagedModelResponseSerializer_Internal.h"
#import "OVCManagedHTTPManager_Internal.h"
#import <CoreData/CoreData.h>

@interface OVCManagedHTTPSessionManager () <OVCManagedHTTPManager_Internal>

@end

@implementation OVCManagedHTTPSessionManager

@synthesize managedObjectContext = _managedObjectContext, backgroundContext = _backgroundContext;
@synthesize contextObserver = _contextObserver;

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:url managedObjectContext:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           managedObjectContext:(NSManagedObjectContext *)context
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        _managedObjectContext = context;
        OVCManagedHTTPManagerSetupBackgroundContext(self);
        self.responseSerializer = OVCManagedHTTPManagerCreateManagedModelResponseSerializer(self);
    }
    return self;
}

- (void)dealloc {
    if (self.contextObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.contextObserver];
    }
}

@end
