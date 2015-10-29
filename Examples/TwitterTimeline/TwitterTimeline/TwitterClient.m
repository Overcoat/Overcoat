// TwitterClient.m
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

#import "TwitterClient.h"
#import "TwitterErrorResponse.h"
#import "Tweet.h"
#import "TwitterUser.h"
#import "UserIdentifierCollection.h"
#import <Overcoat/Overcoat.h>
#import <PromiseKit/PromiseKit.h>

static NSString * const kBaseURL = @"https://api.twitter.com/1.1/";

@implementation TwitterClient

#pragma mark - Properties

- (ACAccount *)account {
    return [(OVCSocialRequestSerializer *)self.requestSerializer account];
}

#pragma mark - Lifecycle

- (id)initWithAccount:(ACAccount *)account managedObjectContext:(NSManagedObjectContext *)context {
    if (self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]
                 managedObjectContext:context
                 sessionConfiguration:nil]) {
        self.requestSerializer = [OVCSocialRequestSerializer serializerWithAccount:account];
    }
    
    return self;
}

#pragma mark - Requests

- (AnyPromise *)fetchTimeline:(TimelineType)timelineType parameters:(NSDictionary *)parameters {
    NSString *path = [NSString stringWithFormat:@"statuses/%@.json", timeline_name(timelineType)];
    
    return [self GET:path parameters:parameters].then(^(OVCResponse *response) {
        return response.result;
    });
}

- (AnyPromise *)fetchFriendIdentifiersWithCursor:(NSNumber *)cursor {
    NSDictionary *parameters = @{
        @"screen_name": self.account.username,
        @"cursor": cursor ? [cursor stringValue] : @"-1",
        @"count": @"100"
    };
    
    return [self GET:@"friends/ids.json" parameters:parameters].then(^(OVCResponse *response) {
        return response.result;
    });
}

- (AnyPromise *)fetchFollowerIdentifiersWithCursor:(NSNumber *)cursor {
    NSDictionary *parameters = @{
        @"screen_name": self.account.username,
        @"cursor": cursor ? [cursor stringValue] : @"-1",
        @"count": @"100"
    };
    
    return [self GET:@"followers/ids.json" parameters:parameters].then(^(OVCResponse *response) {
        return response.result;
    });
}

- (AnyPromise *)lookupUsersWithIdentifiers:(NSArray *)identifiers {
    NSDictionary *parameters = @{
        @"screen_name": self.account.username,
        @"user_id": [identifiers componentsJoinedByString:@","]
    };

    return [self GET:@"users/lookup.json" parameters:parameters].then(^(OVCResponse *response) {
        return response.result;
    });
}

#pragma mark - OVCHTTPSessionManager

+ (Class)errorModelClass {
    return [TwitterErrorResponse class];
}

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
        @"statuses/*": [Tweet class],
        @"users/*": [TwitterUser class],
        @"friends/ids.json": [UserIdentifierCollection class],
        @"followers/ids.json": [UserIdentifierCollection class]
    };
}

@end
