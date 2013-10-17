//
//  OVCTestCase.m
//  Overcoat
//
//  Created by guille on 01/08/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import "OVCTestCase.h"

@interface OVCTestCase ()

@property (strong, nonatomic) NSMutableArray *mocksToVerify;

@end

@implementation OVCTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    for (id mock in self.mocksToVerify) {
        [mock verify];
    }
    self.mocksToVerify = nil;
    [super tearDown];
}

- (id)autoVerifiedMockForClass:(Class)aClass {
    id mock = [OCMockObject mockForClass:aClass];
    [self verifyDuringTearDown:mock];
    return mock;
}

- (id)autoVerifiedPartialMockForObject:(id)object {
    id mock = [OCMockObject partialMockForObject:object];
    [self verifyDuringTearDown:mock];
    return mock;
}

- (void)verifyDuringTearDown:(id)mock {
    if (self.mocksToVerify == nil) {
        self.mocksToVerify = [NSMutableArray array];
    }
    [self.mocksToVerify addObject:mock];
}

@end
