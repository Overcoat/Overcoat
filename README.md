# Overcoat

Overcoat is a small but powerful library that makes creating REST clients simple and fun. It provides a simple API for making requests and mapping responses to model objects.

Overcoat is built on top of [AFNetworking](https://github.com/AFNetworking/AFNetworking) and uses [Mantle](https://github.com/Mantle/Mantle) to map responses into plain or Core Data model objects.

If you need to learn more about Mantle, we recommend these resources:

1. [Introduction](https://github.com/Mantle/Mantle/blob/master/README.md).
2. [Better Web Clients with Mantle and AFNetworking](https://speakerdeck.com/gonzalezreal/better-web-clients-with-mantle-and-afnetworking).

**Overcoat 2.0** is the latest major release and introduces several API-breaking changes to support envelop and error responses, Core Data serialization, and a new method to specify how to map responses to model objects.

## Requirements

Overcoat supports OS X 10.8+ and iOS 6.0+. `OVCHTTPSessionManager` requires OS X 10.9+ or iOS 7.0+.

## Installation

Add the following to your `Podfile` and run `$ pod install`.

``` ruby
pod 'Overcoat', '~>2.0'
```

If you don't have CocoaPods installed or integrated into your project, you can learn how to do so [here](http://cocoapods.org).

## Sample Code

Overcoat includes a simple [Twitter](https://dev.twitter.com/docs/api/1.1) client that shows some new features:

* Mapping model classes to resource paths.
* Specifying an error model class.
* Core Data serialization.
* Promises.

You can find the sample code [here](https://github.com/gonzalezreal/Overcoat/tree/master/Examples/TwitterTimeline). Note that you'll need to run `pod install` to install all the dependencies.

## Usage

### Creating a Client Class
Overcoat provides two different classes to subclass when creating your own clients:

* `OVCHTTPRequestOperationManager` based on `NSURLConnection`
* `OVCHTTPSessionManager` based on `NSURLSession`

Both classes have identical APIs, but developers targeting OS X 10.9+ or iOS 7.0+ are encouraged to subclass `OVCHTTPSessionManager`. Developers targeting OS X 10.8 or iOS 6.0 must subclass `OVCHTTPRequestOperationManager`.

```objc
#import <Overcoat/Overcoat.h>

@interface TwitterClient : OVCHTTPSessionManager
...
@end
```

### Specifying Model Classes
To specify how responses should be mapped to model classes you must override `+modelClassesByResourcePath` and return a dictionary mapping resource paths to model classes.

```objc
+ (NSDictionary *)modelClassesByResourcePath {
    return @{
               @"statuses/*": [Tweet class],
               @"users/*": [TwitterUser class],
               @"friends/ids.json": [UserIdentifierCollection class],
               @"followers/ids.json": [UserIdentifierCollection class]
    };
}
```

You don't need to specify the full path, and you can use `*` to match any text or `#` to match only digits. However, **path matching is strict and the number of path components must be equal**.

### Envelop and Error Responses
Different REST APIs have different ways of dealing with status and other metadata.

Pure REST services like **Twitter** use HTTP status codes and a specific JSON response to communicate errors; and HTTP headers for other metadata like rate limits. For these kind of services, you may want to override `+errorModelClass` to map error responses into your own model.

```objc
+ (Class)errorModelClass {
    return [TwitterErrorResponse class];
}
```

Other services like **App.net** use an envelop response, which is a top level JSON response containing the data requested and additional metadata. For these kind of services, you must create your own `OVCResponse` subclass and specify the data key path.

```objc
@interface AppDotNetResponse : OVCResponse
...
@end

@implementation AppDotNetResponse
+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
    return @"data";
}
@end
```

You can then specify which response class to use in your client by overriding `+responseClass`.

```objc
+ (Class)responseClass {
    return [AppDotNetResponse class];
}
```

### Core Data Serialization
If you initialize your client with a valid `NSManagedObjectContext`, it will automatically persist any model object(s) parsed from a response, if the model supports Core Data serialization (that is, implements `MTLManagedObjectSerializing`).

Note that, if you provide a context with an `NSMainQueueConcurrencyType`, a private context will be created to perform insertions in the background.

You can see Core Data Serialization in action in the [provided example](https://github.com/gonzalezreal/Overcoat/tree/master/Examples/TwitterTimeline).

### Making HTTP Requests
Both `OVCHTTPRequestOperationManager` and `OVCHTTPSessionManager` provide the same methods for making HTTP requests.

```objc
// Lookup Twitter users
NSDictionary *parameters = @{
    @"screen_name": @"gonzalezreal",
    @"user_id": @"42,3141592"
};

[twitterClient GET:@"users/lookup.json" parameters:parameters completion:^(OVCResponse *response, NSError *error) {
    NSArray *users = response.result; // This is an array of TwitterUser objects!
}];
```

Note that Overcoat automatically parses the JSON into model objects, that is, in this case `response.result` contains an array of `TwitterUser` objects.

#### ReactiveCocoa
Overcoat 2.0 adds support for [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa).

Add the following to your `Podfile` to install Overcoat with ReactiveCocoa support:

``` ruby
pod 'Overcoat/ReactiveCocoa', '~>2.0'
```

Now you can make HTTP requests and get cold signals to handle responses:

```objc
#import <Overcoat/ReactiveCocoa+Overcoat.h>
...
[[twitterClient rac_GET:@"users/lookup.json" parameters:parameters] subscribeNext:^(OVCResponse *response) {
    ...
} error:^(NSError *e) {
    ...
}];
```

#### PromiseKit
If you're looking for a better way to handle asynchronous calls but you're not ready to embrace ReactiveCocoa, you may try [PromiseKit](http://promisekit.org).

Add the following to your `Podfile` to install Overcoat with PromiseKit support:

``` ruby
pod 'Overcoat/PromiseKit', '~>2.0'
```

Now you can get `PMKPromise` objects when making HTTP requests:

```objc
#import <Overcoat/PromiseKit+Overcoat.h>
...
[twitterClient GET:@"users/lookup.json" parameters:parameters].then(^(OVCResponse *response) {
    return response.result;
});
```

## Building the library

In order to build the library and run unit tests, you will first need to install project dependencies by running `$ pod install` in the project directory.

Once the process is complete open the generated `Overcoat.xcworkspace` with **Xcode**.

## Contact

[Guillermo Gonzalez](http://github.com/gonzalezreal)  
[@gonzalezreal](https://twitter.com/gonzalezreal)

## License

Overcoat is available under the MIT license. See [LICENSE.md](https://github.com/gonzalezreal/Overcoat/blob/master/LICENSE).
