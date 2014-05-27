//
//  Timeline.h
//  TwitterTimeline
//
//  Created by guille on 27/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "TimelineType.h"

@class ACAccount;
@class Promise;

@interface Timeline : NSObject

@property (strong, nonatomic, readonly) ACAccount *account;

@property (nonatomic, readonly) TimelineType type;

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (NSFetchRequest *)fetchRequest;

- (id)initWithAccount:(ACAccount *)account type:(TimelineType)type;

- (Promise *)refresh;

- (Promise *)loadMoreTweets;

- (void)cancelAllRequests;

@end
