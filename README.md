# Overcoat

Overcoat is an [AFNetworking](https://github.com/AFNetworking/AFNetworking) extension that makes it super simple for developers to use Mantle model objects with a REST client.

You can learn more about Mantle [here](https://github.com/github/Mantle/blob/master/README.md).

## Usage

In Overcoat, server API requests are defined by instances of the `OVCQuery` class. Using `OVCQuery` you can specify an HTTP method, a path that identifies the resource, a set of parameters, and a model class.

Servers typically respond to client API request with a dictionary or an array of dictionaries. Overcoat will transparently map those into model objects in a background queue.

For example, using [this](https://github.com/github/Mantle/blob/master/README.md#mtlmodel) model of a GitHub issue, here is how we could use the [GitHub API](http://developer.github.com) to list all the closed issues.

```objc
OVCClient *gitHubClient = [[OVCClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.github.com"]];
[gitHubClient setAuthorizationHeaderWithUsername:@"johndoe" password:@"secret"];

OVCQuery *closedIssues = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/user/issues" parameters:@{
        @"state" : @"closed"
} modelClass:[GHIssue class]];

[gitHubClient executeQuery:closedIssues completionBlock:^(OVCRequestOperation *operation, NSArray *issues, NSError *error) {
    if (!error) {
        for (GHIssue *issue in issues) {
            NSLog(@"issue: %@ title: %@", issue.number, issue.title);
        }
    }
}];
```

### Social Client

Overcoat features a special client class which can authenticate API requests using an `ACAccount` object on supported social networking services (currently Twitter, Facebook, and Sina Weibo).

Here is how we could lookup for Twitter users.

```objc
@interface TwitterUser : MTLModel

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *screenName;
@property (copy, nonatomic) NSURL *profileImageURL;

@end
```

```objc
@implementation TwitterUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id_str",
        @"screenName": @"screen_name",
        @"profileImageURL": @"profile_image_url"
    };
}

+ (NSValueTransformer *)profileImageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
```

```objc
OVCSocialClient *twitterClient = [[OVCSocialClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1"]];
twitterClient.account = myAccount;

OVCQuery *lookupUsers = [OVCQuery queryWithMethod:OVCQueryMethodGet path:@"/users/lookup.json" parameters:@{
        @"screen_name" : @"twitterapi,twitter"
} modelClass:[TwitterUser class]];

[twitterClient executeQuery:lookupUsers completionBlock:^(OVCRequestOperation *operation, NSArray *users, NSError *error) {
    if (!error) {
        for (TwitterUser *user in users) {
            NSLog(@"name: %@ screenName: %@", user.name, user.screenName);
        }
    }
}];
```

## Contact

[Guillermo Gonzalez](http://github.com/gonzalezreal)  
[@gonzalezreal](https://twitter.com/gonzalezreal)

## License

Overcoat is available under the MIT license. See [LICENSE.md](https://github.com/gonzalezreal/Overcoat/blob/master/LICENSE).
