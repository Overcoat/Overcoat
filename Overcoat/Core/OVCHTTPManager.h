// OVCHTTPManager.h
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

#import <Foundation/Foundation.h>

@protocol OVCHTTPManager <NSObject>

@property (readonly) NSURL *baseURL;

/**
 Returns the class used to create responses.

 This method returns the `OVCResponse` class object by default. Subclasses can override this method
 and return a different `OVCResponse` subclass as needed.

 @return The class that used to create responses.
 */
+ (Class)responseClass;

/**
 Specifies a model class for server error responses.

 This method returns `Nil` by default. Subclasses can override this method and return an `MTLModel`
 subclass that will be used to parse the JSON in an error response.
 */
+ (Class)errorModelClass;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcomment"
/**
 Specifies how to map responses to different model classes.

 Subclasses must override this method and return a dictionary mapping resource paths to model
 classes. Consider the following example for a GitHub client:

 + (NSDictionary *)modelClassesByResourcePath {
 return @{
 @"/users/*": [GTHUser class],
 @"/orgs/*": [GTHOrganization class]
 }
 }

 Note that you can use `*` to match any text or `#` to match only digits.

 @return A dictionary mapping resource paths to model classes.
 */
#pragma clang diagnostic pop
+ (NSDictionary *)modelClassesByResourcePath;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcomment"
/**
 Specifies how to map responses to different response classes. Not mandatory.
 It's intended to address the following case: https://github.com/gonzalezreal/Overcoat/issues/50

 Subclasses can override this method and return a dictionary mapping resource paths to response
 classes. Consider the following example for a GitHub client:

 + (NSDictionary *)responseClassesByResourcePath {
 return @{
 @"/users/*": [GTHUserResponse class],
 @"/orgs/*": [GTHOrganizationResponse class]
 }
 }

 Note that you can use `*` to match any text or `#` to match only digits.
 If a subclass override this method, the responseClass method will be ignored

 @return A dictionary mapping resource paths to response classes.
 */
#pragma clang diagnostic pop
+ (NSDictionary *)responseClassesByResourcePath;

@end
