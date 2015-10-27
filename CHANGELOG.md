# Overcoat Changelog

## Upcoming

* Adding error pointer to the initializer of OVCResponse. [Pull Request #108](https://github.com/Overcoat/Overcoat/pull/108) (@melbic)

## 3.2

* PromiseKit 2.x support. [Commit f444f00 ](https://github.com/Overcoat/Overcoat/commit/f444f00a726967f7bcb76585da47fa1a4cd8aa5d)
* Replace inheritance of OVCModelResponseSerializer with composite a json serializer. [Pull Request #104](https://github.com/Overcoat/Overcoat/pull/104) (@melbic)

## 3.1.1

* Make sure the NSURLSessionDataTask isn't suspended. [Pull Request #102](https://github.com/Overcoat/Overcoat/pull/102) (@zinthemoney)
* Add `pod_target_xcconfig` settings to make Overcoat able to build while using as a dependency of another pod package. [Issue #99](https://github.com/Overcoat/Overcoat/issues/99) (@NorbertSzydlowski)

## 3.1

* Annotate nullability and lighweight generics of Objective-C [Issue #90](https://github.com/Overcoat/Overcoat/issues/90) (@sodastsai)
* Change podspec to drop support of `iOS 6.0` and `OS X 10.8`. (so now we support iOS 7.0+ and OS X 10.9+) (@sodastsai)

## 3.0

* Support Mantle 2.0. [Pull Request #87](https://github.com/Overcoat/Overcoat/pull/87) (@sodastsai)
* Refine project structure including reorganizing folders, use subspecs, and share common codes
  [Pull Request #91](https://github.com/Overcoat/Overcoat/pull/91) (commits) (@sodastsai, @ryanmaxwell)
* Refine the dependency to PromiseKit. [Pull Request #85](https://github.com/Overcoat/Overcoat/pull/85) (@mxcl)
* Fix Core Data threading issue when saving objects [Pull Request #76](https://github.com/Overcoat/Overcoat/pull/76) (@nunofgs)
* Adding a Wildcard URL Matcher and Fix URL pattern matching for higher level paths [Pull Request #94](https://github.com/Overcoat/Overcoat/pull/94) [Pull Request #55](https://github.com/Overcoat/Overcoat/pull/55) (@brandons, @groomsy)

### Summary of 3.0 release

* Support Mantle 2.0
* Use podspec to re-organize features. (Take `CoreData` and `Social` support apart from `Core`)
* Separate `CoreData` classes (for example, `OVCHTTPSessionManager` -> `OVCManagedHTTPSessionManager`)

### Migrate from 2.x

#### 1. Mantle 2.x Support

By default, Overcoat 3.x installs **Mantle 2.x** as dependency.
If you still have to stick with **Mantle 1.x**, then besides adding Overcoat, you have to specify this explicitly by:
```ruby
pod 'Mantle', '~> 1.5'
```

#### 2. Podspec change

The podspec has been changed, so you may have to change your `Podfile` into:

* if you just use AFNetworking and Mantle but don't use CoreData, you don't have to change anything. (but the version number)
```ruby
pod 'Overcoat', '~> 3.0'
```
* if you want to use Overcoat with CoreData
```ruby
# With Mantle 2.x
pod 'Overcoat/CoreData', '~> 3.0'
# Or with Mantle 1.x
pod 'Overcoat/CoreData/Mantle1', '~> 3.0'
```
* if you want to use Overcoat with Social request serializer
```ruby
pod 'Overcoat/Social`, '~> 3.0'
```
* if you want to use multiple Overcoat subspecs
```ruby
pod 'Overcoat', :subspecs => ['CoreData', 'Social'], '~> 3.0'
```
* The support of `PromiseKit` and `ReactiveCocoa` are not changed, so you could keep using
```ruby
pod 'Overcoat/PromiseKit', '~> 3.0'
pod 'Overcoat/ReactiveCocoa', '~> 3.0'
```
* The support of `NSURLSession` has been merged into the `Core` subspec, so you could just use
```ruby
pod 'Overcoat', '~> 3.0'
```

#### 3. Classes/Procotols changes

CoreData support of following classes:

* `OVCHTTPRequestOperationManager`
* `OVCHTTPSessionManager`
* `OVCModelResponseSerializer`

has been move to their subclasses:

Original class                   | CoreData support subclass
-------------------------------- | ------------------------------------
`OVCHTTPRequestOperationManager` | `OVCManagedHTTPSessionManager`
`OVCHTTPSessionManager`          | `OVCManagedHTTPSessionManager`
`OVCModelResponseSerializer`     | `OVCManagedModelResponseSerializer`

In most cases, you could just switch your class name from orginial one to CoreData-supported one
if you are using CoreData support.

Also there are two base procotols:

* `OVCHTTPManager` defines common interfaces of `OVCHTTPSessionManager` and `OVCHTTPRequestOperationManager`.
* `OVCManagedHTTPManager` extends the `OVCHTTPManager` protocl and defines common interfaces for CoreData support.
