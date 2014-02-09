# Overcoat

[![Build Status](https://travis-ci.org/gonzalezreal/Overcoat.png?branch=master)](https://travis-ci.org/gonzalezreal/Overcoat)

Overcoat is an [AFNetworking](https://github.com/AFNetworking/AFNetworking) extension that makes it extremely simple for developers to use Mantle model objects with a REST client.

If you need to learn more about Mantle, we recommend these resources:

1. [Introduction](https://github.com/github/Mantle/blob/master/README.md).
2. [Better Web Clients with Mantle and AFNetworking](https://speakerdeck.com/gonzalezreal/better-web-clients-with-mantle-and-afnetworking).

## Example: Searching books in iTunes

We will use the [iTunes Search API](http://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html) to create a class that searches for books in the iTunes Store.

First, lets create a book model using **Mantle**:

```objc
@interface TGRBook : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *author;
@property (copy, nonatomic, readonly) NSString *overview;
@property (copy, nonatomic, readonly) NSArray *genres;
@property (copy, nonatomic, readonly) NSDate *releaseDate;
@property (copy, nonatomic, readonly) NSNumber *identifier;
@property (copy, nonatomic, readonly) NSString *title;
@property (copy, nonatomic, readonly) NSURL *coverURL;

@end
```

The **iTunes Search API** will return a JSON with the following format:

```json
{
	"resultCount": 50,
	"results": [{
		"artistId": 3603584,
		"artistName": "Neil Gaiman, Sam Kieth & Mike Dringenberg",
		"kind": "ebook",
		"price": 1.99,
		"description": "<p>The first issue of the first volume...",
		"currency": "USD",
		"genres": ["Graphic Novels", "Books", "Comics & Graphic Novels"],
		"genreIds": ["10015", "38", "9026"],
		"releaseDate": "2013-05-01T07:00:00Z",
		"trackId": 642469670,
		"trackName": "Sandman #1",
		...
```

We need to tell our model how to map JSON keys to properties. We can do that by implementing the `MTLJSONSerializing` protocol:

```objc
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
            @"author": @"artistName",
            @"overview": @"description",
            @"identifier": @"trackId",
            @"title": @"trackName",
            @"coverURL": @"artworkUrl100"
    };
}

+ (NSValueTransformer *)releaseDateJSONTransformer {
    ...
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [self.dateFormatter dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)coverURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
```

Once we have the model, we can create an `OVCClient` subclass that will implement the search method:

```objc
@interface TGRBookCatalog : OVCClient

- (void)searchBooksWithTerm:(NSString *)term completion:(void (^)(NSArray *results, NSError *error))block;

@end
```

The implementation of `TGRBookCatalog` is pretty simple:

```objc
- (id)init {
    return [super initWithBaseURL:[NSURL URLWithString:@"https://itunes.apple.com"]];
}

- (void)searchBooksWithTerm:(NSString *)term completion:(void (^)(NSArray *results, NSError *error))block {
    NSDictionary *parameters = @{
            @"term": term,
            @"entity": @"ebook"
    };

    [self GET:@"search" parameters:parameters resultClass:TGRBook.class resultKeyPath:@"results" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
        block(responseObject, error);
    }];
}
```

`OVCClient` provides methods to make `GET`, `POST` and `PUT` requests specifiying how to map the response to a model object. In this case we are telling `OVCClient` that we want `TGRBook` objects that can be found under the key `results` in the JSON response.

Now we can use `TGRBookCatalog` to launch a search in iTunes and get an array of `TGRBook` objects:

```objc
[self.bookCatalog searchBooksWithTerm:@"the sandman" completionBlock:^(NSArray *results, NSError *error) {
    if (error == nil) {
        NSLog(@"results: %@", results); // results is an array of TGRBook instances!
    }
}];
```

You can find the complete example (including `TGRBook` serialization to a **Core Data** entity) [here](https://github.com/gonzalezreal/ReadingList).

### ACAccount authentication

`OVCClient` can authenticate API requests using an `ACAccount` object on supported social networking services (currently Twitter, Facebook, and Sina Weibo).

For example, here is how we could lookup for Twitter users (provided that we have an Twitter account).

```objc
@interface TwitterUser : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic, readonly) NSString *identifier;
@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *screenName;

@end
```

```objc
@implementation TwitterUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id_str",
        @"screenName": @"screen_name"
    };
}

@end
```

```objc
OVCClient *client = [OVCClient clientWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/1.1"]
                                         account:myAccount];

NSDictionary *parameters = @{
         @"screen_name": @"twitterapi,twitter"
};

[client GET:@"users/lookup.json" parameters:parameters resultClass:TwitterUser.class resultKeyPath:nil completion:^(AFHTTPRequestOperation *operation, NSArray *users, NSError *error) {
    if (!error) {
        for (TwitterUser *user in users) {
            NSLog(@"name: %@ screenName: %@", user.name, user.screenName);
        }
    }
}];
```

## Installation

Add the following to your `Podfile` and run `$ pod install`.

``` ruby
pod 'Overcoat', '~>1.2'
```

 If you don't have CocoaPods installed or integrated into your project, you can learn how to do so [here](http://cocoapods.org).

## Building the library

In order to build the library and run unit tests, you will first need to install project dependencies by running `$ pod install` in the project directory.

Once the process is complete open the generated `Overcoat.xcworkspace` with **Xcode**.

## Sample Application

[ReadingList](https://github.com/gonzalezreal/ReadingList) is a fairly complete iOS sample application that shows how to use Overcoat.

## Contact

[Guillermo Gonzalez](http://github.com/gonzalezreal)  
[@gonzalezreal](https://twitter.com/gonzalezreal)

## License

Overcoat is available under the MIT license. See [LICENSE.md](https://github.com/gonzalezreal/Overcoat/blob/master/LICENSE).
