//
//  TimelineViewController.h
//  TwitterTimeline
//
//  Created by guille on 27/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "TGRFetchedResultsTableViewController.h"
#import "TimelineType.h"

#import <Accounts/Accounts.h>

@interface TimelineViewController : TGRFetchedResultsTableViewController

@property (strong, nonatomic) ACAccount *account;
@property (nonatomic) TimelineType type;

@end
