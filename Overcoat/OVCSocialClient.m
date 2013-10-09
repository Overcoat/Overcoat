// OVCSocialClient.m
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

#import "OVCSocialClient.h"
#import "OVCSocialRequestSerializer.h"

@interface OVCSocialClient ()

@property (strong, nonatomic, readonly) OVCSocialRequestSerializer *socialRequestSerializer;

@end

@implementation OVCSocialClient

- (ACAccount *)account {
    return self.socialRequestSerializer.account;
}

- (NSString *)serviceType {
    return self.socialRequestSerializer.serviceType;
}

- (id)initWithAccount:(ACAccount *)account baseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer = [OVCSocialRequestSerializer serializerWithAccount:account];
    }
    
    return self;
}

- (id)initWithServiceType:(NSString *)serviceType baseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.requestSerializer = [OVCSocialRequestSerializer serializerWithServiceType:serviceType];
    }
    
    return self;
}

#pragma mark - Private methods

- (OVCSocialRequestSerializer *)socialRequestSerializer {
    if ([self.requestSerializer isKindOfClass:OVCSocialRequestSerializer.class]) {
        return (OVCSocialRequestSerializer *)self.requestSerializer;
    }
    
    return nil;
}

@end


