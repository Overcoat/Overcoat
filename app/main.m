//
//  main.m
//  OvercoatApp
//
//  Created by sodas on 12/1/15.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nullable, strong, nonatomic) UIWindow *window;

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
#else
#import <AppKit/AppKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@end

int main(int argc, const char * argv[]) {
    return NSApplicationMain(argc, argv);
}
#endif

@implementation AppDelegate

@end
