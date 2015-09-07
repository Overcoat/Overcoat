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
#import <Overcoat/OVCUtilities.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OVCHTTPManager <NSObject>

@property (readonly, OVC_NULLABLE) NSURL *baseURL;

/**
 Returns the class used to create responses.

 This method returns the `OVCResponse` class object by default. Subclasses can override this method
 and return a different `OVCResponse` subclass as needed.

 @return The class that used to create responses.
 */
+ (Class)responseClass;

/**
 Specifies a model class for server error responses.

 This method returns `nil` by default. Subclasses can override this method and return an `MTLModel`
 subclass that will be used to parse the JSON in an error response.
 */
+ (OVC_NULLABLE Class)errorModelClass;

/**
 Specifies how to map responses to different model classes.
 
 Subclasses must override this method and return a dictionary mapping resource paths to model
 classes. 
 Note that you can use `*` and `**` to match any text or `#` to match only digits.

 @see https://github.com/Overcoat/Overcoat#specifying-model-classes
 
 @return A dictionary mapping resource paths to model classes.
 */
+ (NSDictionary OVCGenerics(NSString *, Class) *)modelClassesByResourcePath;

/**
 Specifies how to map responses to different response classes. Not mandatory.
 It's intended to address the following case: https://github.com/gonzalezreal/Overcoat/issues/50

 Subclasses can override this method and return a dictionary mapping resource paths to response
 classes. Consider the following example for a GitHub client:

 + (NSDictionary *)responseClassesByResourcePath {
     return @{
         @"/users": [GTHUserResponse class],
         @"/orgs": [GTHOrganizationResponse class]
     };
 }

 Note that you can use `*` to match any text or `#` to match only digits.
 If a subclass override this method, the responseClass method will be ignored

 @return A dictionary mapping resource paths to response classes.
 */
+ (OVC_NULLABLE NSDictionary OVCGenerics(NSString *, Class) *)responseClassesByResourcePath;

@end

NS_ASSUME_NONNULL_END
