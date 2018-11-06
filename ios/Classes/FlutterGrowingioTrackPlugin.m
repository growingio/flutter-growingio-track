#import "FlutterGrowingIOTrackPlugin.h"
#import <GrowingCoreKit/GrowingCoreKit.h>
@implementation FlutterGrowingIOTrackPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_growingio_track"
            binaryMessenger:[registrar messenger]];
  FlutterGrowingIOTrackPlugin* instance = [[FlutterGrowingIOTrackPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [self methodName:call.method andArguments:call.arguments];
}
//打点事件方法
-(void)methodName:(NSString *)methodName andArguments:(id)arguments{
    if (![arguments isKindOfClass:[NSDictionary class]] && ![methodName isEqualToString:@"clearUserId"]) {
        return ;
    }
    NSDictionary *argDic = arguments ;
    if ([methodName isEqualToString:@"track"]) {
        NSString *eventID = argDic[@"eventId"];
        NSDictionary *variable = argDic[@"variable"];
        NSNumber *num = (NSNumber *)argDic[@"num"];
        if (num && eventID && variable) {
            [Growing track:eventID withNumber:num andVariable:variable];
            return ;
        }else if (num && eventID) {
            [Growing track:eventID withNumber:num];
            return ;
        }else if (eventID && variable){
            [Growing track:eventID withVariable:variable];
            return ;
        }else if (eventID){
            [Growing track:eventID];
            return ;
        }
    }
    if ([methodName isEqualToString:@"setEvar"]) {
        [Growing setEvar:argDic];
    }
    if ([methodName isEqualToString:@"setPeopleVariable"]) {
        [Growing setPeopleVariable:argDic];
    }
    if ([methodName isEqualToString:@"setUserId"]) {
        NSString *userId = argDic[@"userId"];
        [Growing setUserId:userId];
    }
    if ([methodName isEqualToString:@"clearUserId"]) {
        [Growing clearUserId];
    }
    if ([methodName isEqualToString:@"setVisitor"]) {
        [Growing setVisitor:argDic];
    }
}

@end
