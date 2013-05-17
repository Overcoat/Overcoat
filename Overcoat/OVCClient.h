// OVCClient.h
// 
// Copyright (c) 2013 Guillermo Gonzalez
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

#import "AFHTTPClient.h"

@class OVCRequestOperation;
@class OVCQuery;

// AFHTTPClient subclass that provides Overcoat query execution.
@interface OVCClient : AFHTTPClient

// Creates an OVCRequestOperation that executes the specified query, and adds it to the
// HTTP client's operation queue.
//
// query           - The query to be executed. Must be a valid query.
// completionBlock - A block to be executed when the operation finishes.
//
// If the operation completes successfully, the 'object' parameter of the completion block contains the model or
// array of model objects created from the response, and the 'error' parameter is nil. If the operation fails, the
// 'object' parameter is nil and the error parameter contains information about the failure.
- (OVCRequestOperation *)executeQuery:(OVCQuery *)query completionBlock:(void (^)(OVCRequestOperation *operation, id object, NSError *error))block;

// Creates an 'NSMutableURLRequest' with the specified query.
- (NSMutableURLRequest *)requestWithQuery:(OVCQuery *)query;

@end
