// Timeline.m
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

#import "Timeline.h"
#import "TwitterClient.h"

static NSString * const kIdentifierKey = @"identifier";

@interface Timeline ()

@property (strong, nonatomic) ACAccount *account;
@property (nonatomic) TimelineType type;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) TwitterClient *client;
@property (strong, nonatomic) OVCManagedStore *store;

@end

@implementation Timeline

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.store.persistentStoreCoordinator;
    }
    
    return _managedObjectContext;
}

+ (NSFetchRequest *)fetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Tweet"];
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentStatus = nil"];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kIdentifierKey
                                                                 ascending:NO];
    [fetchRequest setSortDescriptors:@[descriptor]];
    
    return fetchRequest;
}

#pragma mark - Lifecycle

- (id)initWithAccount:(ACAccount *)account type:(TimelineType)type {
    NSParameterAssert(account);
    
    self = [super init];
    
    if (self) {
        self.account = account;
        self.type = type;
    }
    
    return self;
}

#pragma mark - Fetching tweets

- (Promise *)refresh {
    NSDictionary *parameters = @{
        @"include_rts": @"true"
    };
    
    NSNumber *identifier = [self lastTweetIdentifier];
    
    if (identifier) {
        parameters = [parameters mtl_dictionaryByAddingEntriesFromDictionary:@{
                          @"since_id": [identifier stringValue]
                      }];
    }
    
    return [self.client fetchTimeline:self.type parameters:parameters];
}

- (Promise *)loadMoreTweets {
    NSNumber *identifier = [self firstTweetIdentifier];
    NSAssert(identifier, @"loadMoreTweets should not be called when the cache is empty");
    
    identifier = @([identifier longLongValue] - 1);
    
    NSDictionary *parameters = @{
        @"include_rts": @"true",
        @"max_id": [identifier stringValue]
    };
    
    return [self.client fetchTimeline:self.type parameters:parameters];
}

- (void)cancelAllRequests {
    [self.client invalidateSessionCancelingTasks:YES];
    self.client = nil;
}

#pragma mark - Private properties

- (TwitterClient *)client {
    if (!_client) {
        _client = [[TwitterClient alloc] initWithAccount:self.account
                                    managedObjectContext:self.managedObjectContext];
    }
    
    return _client;
}

- (OVCManagedStore *)store {
    if (!_store) {
        NSString *cacheName = [NSString stringWithFormat:@"%@_%@", self.account.identifier,
                               timeline_name(self.type)];
        _store = [OVCManagedStore managedStoreWithCacheName:cacheName];
    }
    
    return _store;
}

#pragma mark - Private

- (NSNumber *)firstTweetIdentifier {
    NSFetchRequest *fetchRequest = [[self class] fetchRequest];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kIdentifierKey
                                                                 ascending:YES];
    [fetchRequest setSortDescriptors:@[descriptor]];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:@[@"identifier"]];
    [fetchRequest setFetchLimit:1];
    
    NSDictionary *result = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                     error:NULL] firstObject];
    return result[@"identifier"];
}

- (NSNumber *)lastTweetIdentifier {
    NSFetchRequest *fetchRequest = [[self class] fetchRequest];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:@[@"identifier"]];
    [fetchRequest setFetchLimit:1];
    
    NSDictionary *result = [[self.managedObjectContext executeFetchRequest:fetchRequest
                                                                     error:NULL] firstObject];
    return result[@"identifier"];
}

@end
