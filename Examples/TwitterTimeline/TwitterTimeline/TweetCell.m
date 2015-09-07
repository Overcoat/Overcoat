// TweetCell.m
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

#import "TweetCell.h"
#import "Tweet.h"
#import "TwitterUser.h"

#import "UIImageView+Twitter.h"

@implementation TweetCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.profileImageView prepareForReuse];
}

- (void)configureWithTweet:(Tweet *)tweet {
    if (tweet.retweetedStatus) {
        self.retweetedByLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.user.name];
        tweet = tweet.retweetedStatus;
    } else {
        self.retweetedByLabel.text = nil;
    }
    
    [self configureDateLabelWithDate:tweet.createdAt];
    
    if ([tweet.user.profileImageURL length]) {
        [self.profileImageView setUserProfileImageURL:tweet.user.profileImageURL];
    }
    
    self.nameLabel.text = tweet.user.name;
    self.statusLabel.text = tweet.text;
}

- (CGFloat)height {
    UIView *view = self.retweetedByLabel.text ? self.retweetedByLabel : self.statusLabel;
    return MAX(CGRectGetMaxY(view.frame), CGRectGetMaxY(self.profileImageView.frame)) + 8;
}

- (void)configureDateLabelWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];

#if ((defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) || \
    (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 101000))
    NSCalendarUnit unitFlags = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay;
#else
    NSCalendarUnit unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit;
#endif
    NSDateComponents *components = [calendar components:unitFlags
                                               fromDate:now
                                                 toDate:date
                                                options:0];

    NSString *dateString = NSLocalizedString(@"now", @"");

    if ([components day] != 0) {
        NSUInteger days = ABS([components day]);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"%ud", @""), days];
    } else if ([components hour] != 0) {
        NSUInteger hours = ABS([components hour]);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"%uh", @""), hours];
    } else if ([components minute] != 0) {
        NSUInteger minutes = ABS([components minute]);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"%um", @""), minutes];
    } else if ([components second] != 0) {
        NSUInteger seconds = ABS([components second]);
        dateString = [NSString stringWithFormat:NSLocalizedString(@"%us", @""), seconds];
    }

    self.dateLabel.text = dateString;
}

@end
