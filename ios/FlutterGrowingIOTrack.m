//
//  FlutterGrowingIOTrack.m
//  Runner
//
//  Created by GrowingIO on 2018/10/26.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "FlutterGrowingIOTrack.h"
#import <GrowingCoreKit/GrowingCoreKit.h>
@implementation FlutterGrowingIOTrack
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    [FlutterGrowingIOTrack registerWithRegistrar:[registry registrarForPlugin:@"FlutterGrowingIOTrackPlugin"]];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_growingio_track"
                                     binaryMessenger:[registrar messenger]];
    FlutterGrowingIOTrack* instance = [[FlutterGrowingIOTrack alloc] init];
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
