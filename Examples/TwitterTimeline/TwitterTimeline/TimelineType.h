//
//  TimelineType.h
//  TwitterTimeline
//
//  Created by guille on 27/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TimelineType) {
    TimelineMentions,
    TimelineUser,
    TimelineHome,
    TimelineRetweetsOfMe
};

NSString *timeline_name(TimelineType timeline);
