//
//  OVCTestResponse.m
//  Overcoat
//
//  Created by guille on 18/05/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "OVCTestResponse.h"

@implementation OVCTestResponse

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
    return @"data";
}

#if OVERCOAT_USING_MANTLE_2

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *keyPaths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    keyPaths[@"status"] = @"status";
    return [NSDictionary dictionaryWithDictionary:keyPaths];
}

#endif

@end
