//
//  NSError+OVCResponse.h
//  Overcoat
//
//  Created by guille on 28/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OVCResponse;

extern NSString * const OVCResponseKey;

@interface NSError (OVCResponse)

- (NSError *)ovc_errorWithUnderlyingResponse:(OVCResponse *)response;

- (OVCResponse *)ovc_response;

@end
