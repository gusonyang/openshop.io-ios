//
//  BFUMService.m
//  OpenShop
//
//  Created by GusonYang on 16/8/17.
//  Copyright © 2016年 Business-Factory. All rights reserved.
//


#import "BFUMService.h"
#import "UMMobClick/MobClick.h"

@implementation BFUMService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UMConfigInstance.appKey = @"57b3ce47e0f55ab1b6000bb9";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    return YES;
}

@end
