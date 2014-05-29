//
//  TimelineDataSource.h
//  TwitterTimeline
//
//  Created by guille on 29/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <TGRDataSource/TGRFetchedResultsDataSource.h>

@class Timeline;

@interface TimelineDataSource : TGRFetchedResultsDataSource

- (id)initWithTimeline:(Timeline *)timeline
   cellReuseIdentifier:(NSString *)reuseIdentifier
    configureCellBlock:(TGRDataSourceCellBlock)configureCellBlock;

@end
