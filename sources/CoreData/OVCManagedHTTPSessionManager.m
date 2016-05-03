// OVCManagedHTTPRequestOperationManager.m
// 
// Copyright (c) 2013-2016 Overcoat Team
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
#import "OVCManagedModelResponseSerializer.h"
#import "OVCURLMatcher.h"
#import <CoreData/CoreData.h>

@interface OVCManagedHTTPSessionManager ()

/**
 The managed object context at background used to save results
 */
@property (strong, nonatomic, readonly, OVC_NULLABLE) NSManagedObjectContext *backgroundContext;

/**
 NSNotification Observer of the background context
 */
@property (strong, nonatomic, OVC_NULLABLE) id contextObserver;

@end

@implementation OVCManagedHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    return [self initWithBaseURL:url managedObjectContext:nil sessionConfiguration:configuration];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           managedObjectContext:(NSManagedObjectContext *)context
           sessionConfiguration:(NSURLSessionConfiguration *)configuration {
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        _managedObjectContext = context;
        if (_managedObjectContext.concurrencyType == NSPrivateQueueConcurrencyType) {
            _backgroundContext = _managedObjectContext;
        } else if (_managedObjectContext) {
            _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _backgroundContext.persistentStoreCoordinator = _managedObjectContext.persistentStoreCoordinator;

            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            NSManagedObjectContext *context = _managedObjectContext;

            _contextObserver = [notificationCenter
                                addObserverForName:NSManagedObjectContextDidSaveNotification
                                object:_backgroundContext
                                queue:nil
                                usingBlock:^(NSNotification *note) {
                                    [context performBlock:^{
                                        [context mergeChangesFromContextDidSaveNotification:note];
                                    }];
                                }];
        }

        // Setup response serializer
        self.responseSerializer =
        [OVCManagedModelResponseSerializer
         serializerWithURLMatcher:[OVCURLMatcher matcherWithBasePath:self.baseURL.path
                                                  modelClassesByPath:[[self class] modelClassesByResourcePath]]
         responseClassURLMatcher:[OVCURLMatcher matcherWithBasePath:self.baseURL.path
                                                 modelClassesByPath:[[self class] responseClassesByResourcePath]]
         errorModelClassURLMatcher:[OVCURLMatcher matcherWithBasePath:self.baseURL.path
                                                   modelClassesByPath:[[self class] errorModelClassesByResourcePath]]
         managedObjectContext:self.backgroundContext];
    }
    return self;
}

- (void)dealloc {
    if (self.contextObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.contextObserver];
    }
}

@end
