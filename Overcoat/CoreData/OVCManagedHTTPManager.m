// OVCManagedHTTPManager.m
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

#import "OVCManagedHTTPManager_Internal.h"
#import "OVCManagedHTTPManager.h"
#import "OVCHTTPManager_Internal.h"
#import "OVCManagedModelResponseSerializer.h"
#import <CoreData/CoreData.h>

OVC_EXTERN
OVCManagedModelResponseSerializer *
OVCManagedHTTPManagerCreateManagedModelResponseSerializer(id<OVCManagedHTTPManager_Internal> httpManager) {
    return [OVCManagedModelResponseSerializer
            serializerWithURLMatcher:OVCHTTPManagerCreateURLMatcher(httpManager)
            responseClassURLMatcher:OVCHTTPManagerCreateResponseClassURLMatcher(httpManager)
            managedObjectContext:httpManager.backgroundContext
            responseClass:[[httpManager class] responseClass]
            errorModelClass:[[httpManager class] errorModelClass]];
}

OVC_EXTERN
void OVCManagedHTTPManagerSetupBackgroundContext(id<OVCManagedHTTPManager_Internal> httpManager) {
    if (httpManager.managedObjectContext == nil) {
        return;
    }

    if (httpManager.managedObjectContext.concurrencyType == NSPrivateQueueConcurrencyType) {
        httpManager.backgroundContext = httpManager.managedObjectContext;
        return;
    }

    httpManager.backgroundContext = [[NSManagedObjectContext alloc]
                                     initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    httpManager.backgroundContext.persistentStoreCoordinator =
        httpManager.managedObjectContext.persistentStoreCoordinator;

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSManagedObjectContext *context = httpManager.managedObjectContext;

    httpManager.contextObserver = [notificationCenter addObserverForName:NSManagedObjectContextDidSaveNotification
                                                           object:httpManager.backgroundContext
                                                            queue:nil
                                                       usingBlock:^(NSNotification *note) {
                                                           [context performBlock:^{
                                                               [context
                                                                mergeChangesFromContextDidSaveNotification:note];
                                                           }];
                                                       }];
}
