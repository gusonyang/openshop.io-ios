//
//  XCAPIClient.m
//  OpenShop
//
//  Created by GusonYang on 16/8/18.
//  Copyright © 2016年 Business-Factory. All rights reserved.
//

#import "XCAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.10.106:1212";

@implementation XCAPIClient

+ (instancetype)sharedClient {
    static XCAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}

@end
