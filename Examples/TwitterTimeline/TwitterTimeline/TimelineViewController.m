// TimelineViewController.m
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
    [self.timeline loadMoreTweets].catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
    }).finally(^{
        @strongify(self);
        self.loading = NO;
    });
}

- (void)refresh {
    UIRefreshControl *refreshControl = self.refreshControl;
    [refreshControl beginRefreshing];
    
    [self.timeline refresh].catch(^(NSError *error) {
        NSLog(@"Error: %@", error);
    }).finally(^{
        [refreshControl endRefreshing];
    });
}

@end
