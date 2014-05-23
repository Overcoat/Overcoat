// OVCHTTPRequestOperationManager+BFTask.m
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

#import "OVCHTTPRequestOperationManager+BFTask.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)

#import <Bolts/Bolts.h>

@implementation OVCHTTPRequestOperationManager (BFTask)

- (BFTask *)bf_GET:(NSString *)URLString parameters:(NSDictionary *)parameters {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    [self GET:URLString parameters:parameters completion:^(id response, NSError *error) {
        if (response) {
            [completionSource setResult:response];
        } else if (error) {
            [completionSource setError:error];
        } else {
            [completionSource setResult:nil];
        }
    }];
    
    return completionSource.task;
}

- (BFTask *)bf_HEAD:(NSString *)URLString parameters:(id)parameters {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    
    [self HEAD:URLString parameters:parameters completion:^(id response, NSError *error) {
        if (response) {
            [completionSource setResult:response];
        } else if (error) {
            [completionSource setError:error];
        } else {
            [completionSource setResult:nil];
        }
    }];
    
    return completionSource.task;
}

@end

#endif
