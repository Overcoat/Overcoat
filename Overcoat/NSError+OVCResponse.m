//
//  NSError+OVCResponse.m
//  Overcoat
//
//  Created by guille on 28/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "NSError+OVCResponse.h"

#import <Mantle/NSDictionary+MTLManipulationAdditions.h>

NSString * const OVCResponseKey = @"OVCResponse";

@implementation NSError (OVCResponse)

- (NSError *)ovc_errorWithUnderlyingResponse:(OVCResponse *)response {
    if (response == nil) {
        return self;
    }
    
    NSDictionary *userInfo = @{ OVCResponseKey: response };
    userInfo = [userInfo mtl_dictionaryByAddingEntriesFromDictionary:[self userInfo]];
    
    return [NSError errorWithDomain:[self domain] code:[self code] userInfo:userInfo];
}

- (OVCResponse *)ovc_response {
    return [[self userInfo] objectForKey:OVCResponseKey];
}

@end
