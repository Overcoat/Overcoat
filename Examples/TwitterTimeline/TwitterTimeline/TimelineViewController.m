//
//  TimelineViewController.m
//  TwitterTimeline
//
//  Created by guille on 27/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetCell.h"
#import "Timeline.h"
#import "TimelineDataSource.h"

#import <PromiseKit/PromiseKit.h>
#import <Mantle/EXTScope.h>

static NSString * const kCellIdentifier = @"TweetCell";

@interface TimelineViewController ()

@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) Timeline *timeline;
@property (nonatomic, getter = isLoading) BOOL loading;

@property (strong, nonatomic) TweetCell *prototypeCell;

@end

@implementation TimelineViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = self.footerView;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([TweetCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:kCellIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    
    [self setupTimeline];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if ([self isMovingFromParentViewController]) {
        [self.timeline cancelAllRequests];
    }
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height <= self.view.bounds.size.height) {
        return;
    }
    
    CGFloat distanceToBottom = scrollView.contentSize.height - (scrollView.contentOffset.y + scrollView.frame.size.height);
    
    if (distanceToBottom <= self.tableView.rowHeight && !self.loading && !self.refreshControl.refreshing) {
        [self loadMoreTweets];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = [self.dataSource itemAtIndexPath:indexPath];
    [self.prototypeCell configureWithTweet:tweet];
    [self.prototypeCell layoutIfNeeded];

    return [self.prototypeCell height];
}

#pragma mark - Private

- (void)setLoading:(BOOL)loading {
    if (_loading != loading) {
        _loading = loading;
        
        if (_loading) {
            self.tableView.tableFooterView = self.loadingView;
        } else {
            self.tableView.tableFooterView = self.footerView;
        }
    }
}

- (TweetCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    }
    
    return _prototypeCell;
}

- (void)setupTimeline {
    self.timeline = [[Timeline alloc] initWithAccount:self.account type:self.type];
    
    self.dataSource = [[TimelineDataSource alloc] initWithTimeline:self.timeline
                                               cellReuseIdentifier:kCellIdentifier
                                                configureCellBlock:^(TweetCell *cell, Tweet *item) {
                                                    [cell configureWithTweet:item];
                                                }];
    [self refresh];
}

- (void)loadMoreTweets {
    self.loading = YES;
    
    @weakify(self);
    [self.timeline loadMoreTweets].finally(^{
        @strongify(self);
        self.loading = NO;
    });
}

- (void)refresh {
    UIRefreshControl *refreshControl = self.refreshControl;
    [refreshControl beginRefreshing];
    
    [self.timeline refresh].finally(^{
        [refreshControl endRefreshing];
    });
}

@end
