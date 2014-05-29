//
//  TimelineDataSource.m
//  TwitterTimeline
//
//  Created by guille on 29/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "TimelineDataSource.h"
#import "Timeline.h"
#import "Tweet.h"

@implementation TimelineDataSource

- (id)initWithTimeline:(Timeline *)timeline
   cellReuseIdentifier:(NSString *)reuseIdentifier
    configureCellBlock:(TGRDataSourceCellBlock)configureCellBlock
{
    NSFetchRequest *fetchRequest = [Timeline fetchRequest];
    NSManagedObjectContext *context = timeline.managedObjectContext;
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    
    return [super initWithFetchedResultsController:frc
                               cellReuseIdentifier:reuseIdentifier
                                configureCellBlock:configureCellBlock];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *item = [super itemAtIndexPath:indexPath];
    return [MTLManagedObjectAdapter modelOfClass:[Tweet class] fromManagedObject:item error:NULL];
}

@end
