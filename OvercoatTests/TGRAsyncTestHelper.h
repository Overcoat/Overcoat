//
//  TGRAsyncTestHelper.h
//
//  Created by guille on 23/09/13.
//  Copyright (c) 2013 Guillermo Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TGR_RUNLOOP_INTERVAL 0.05
#define TGR_TIMEOUT_INTERVAL 10.0
#define TGR_RUNLOOP_COUNT TGR_TIMEOUT_INTERVAL / TGR_RUNLOOP_INTERVAL

#define TGR_CAT(x, y) x ## y
#define TGR_TOKCAT(x, y) TGR_CAT(x, y)
#define __runLoopCount TGR_TOKCAT(__runLoopCount,__LINE__)

#define TGRAssertEventually(a1, format...) \
NSUInteger __runLoopCount = 0; \
while (!(a1) && __runLoopCount < TGR_RUNLOOP_COUNT) { \
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:TGR_RUNLOOP_INTERVAL]; \
    [NSRunLoop.currentRunLoop runUntilDate:date]; \
    __runLoopCount++; \
} \
if (__runLoopCount >= TGR_RUNLOOP_COUNT) { \
    XCTFail(format); \
}
