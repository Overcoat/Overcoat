// OVCResponse.h
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

#import <Mantle/Mantle.h>

/**
 Represents a parsed response.
 */
@interface OVCResponse : MTLModel<MTLJSONSerializing>

/**
 The HTTP response.
 */
@property (strong, nonatomic, readonly) NSHTTPURLResponse *HTTPResponse;

/**
 The parsed result.
 
 Depending on the response JSON, this can contain a single `MTLModel` object or an array of
 `MTLModel` objects.
 */
@property (strong, nonatomic, readonly) id result;

/**
 Returns the result key path in the JSON.
 
 This method returns `nil` by default. For JSON responses with additional metadata, subclasses
 should override this method and return the key path of the result.
 */
+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary;

/**
 Attempts to parse a JSON dictionary into an `OVCResponse` object.
 
 @param HTTPResponse The HTTP response.
 @param JSONObject A foundation object with JSON data.
 @param resultClass The `MTLModel` subclass in which `result` will be transformed.
 
 @return A new `OVCResponse` object upon success, or nil if a parsing error occurred.
 */
+ (instancetype)responseWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse
                              JSONObject:(id)JSONObject
                             resultClass:(Class)resultClass;

@end
