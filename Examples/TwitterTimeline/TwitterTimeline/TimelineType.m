//
//  TimelineType.m
//  TwitterTimeline
//
//  Created by guille on 27/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "TimelineType.h"

NSString *timeline_name(TimelineType timeline) {
    static dispatch_once_t onceToken;
    static NSDictionary *names;

    dispatch_once(&onceToken, ^{
        names = @{
            @(TimelineMentions): @"mentions_timeline",
            @(TimelineUser): @"user_timeline",
            @(TimelineHome): @"home_timeline",
            @(TimelineRetweetsOfMe): @"retweets_of_me"
        };
    });

    return names[@(timeline)];
}
