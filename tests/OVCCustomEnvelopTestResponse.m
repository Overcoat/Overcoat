//
//  OVCCustomEnvelopTestResponse.m
//  Overcoat
//
//  Created by Elias Turbay on 9/21/14.
//  Copyright (c) 2014 Guillermo Gonzalez. All rights reserved.
//

#import "OVCCustomEnvelopTestResponse.h"

@implementation OVCCustomEnvelopTestResponse

+ (NSString *)resultKeyPathForJSONDictionary:(NSDictionary *)JSONDictionary {
    return @"model";
}

@end
