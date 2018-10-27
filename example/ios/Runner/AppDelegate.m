#include "AppDelegate.h"
#import "FlutterGrowingIOTrack.h"
#import <GrowingCoreKit/GrowingCoreKit.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Growing startWithAccountId:@"xxxxxxxxxxx"];
  [FlutterGrowingIOTrack registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
