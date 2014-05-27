//
//  Timeline.m
//  TwitterTimeline
//
//  Created by guille on 27/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "Timeline.h"
#import "TwitterClient.h"

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
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"identifier"
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
    return nil;
}

- (Promise *)loadMoreTweets {
    return nil;
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

@end
