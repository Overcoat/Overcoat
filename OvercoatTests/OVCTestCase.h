//
//  OVCTestCase.h
//  Overcoat
//
//  Created by guille on 01/08/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

@interface OVCTestCase : XCTestCase

// Calls +[OCMockObject mockForClass:] and adds the mock and call -verify on it during -tearDown.
- (id)autoVerifiedMockForClass:(Class)aClass;

// Calls +[OCMockObject partialMockForClass:] and adds the mock and call -verify on it during -tearDown.
- (id)autoVerifiedPartialMockForObject:(id)object;

// Calls -verify on the mock during -tearDown.
- (void)verifyDuringTearDown:(id)mock;

@end
