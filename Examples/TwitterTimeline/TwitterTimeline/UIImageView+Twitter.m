// UIImageView+Twitter.m
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

#import "UIImageView+Twitter.h"

#import <AFNetworking/UIKit+AFNetworking.h>
#import <Mantle/EXTScope.h>

static const NSTimeInterval kAnimationDuration = 0.2;
static const UIViewAnimationOptions kAnimationOptions = UIViewAnimationOptionBeginFromCurrentState |
    UIViewAnimationOptionCurveEaseInOut |
    UIViewAnimationOptionTransitionCrossDissolve;


@implementation UIImageView (Twitter)

- (void)setUserProfileImageURL:(NSString *)URLString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    // Return cached image if available regardless of the response cache policy
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    @weakify(self);
    
    [self setImageWithURLRequest:request
                placeholderImage:nil
                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                             @strongify(self);
                             
                             [UIView transitionWithView:self
                                               duration:kAnimationDuration
                                                options:kAnimationOptions
                                             animations:^{
                                                 self.image = image;
                                             }
                                             completion:nil];
                         }
                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                             @strongify(self);
                             self.image = nil;
                         }];
}

- (void)prepareForReuse {
    [self cancelImageRequestOperation];
    self.image = nil;
}

@end
