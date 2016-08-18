//
//  XCAPIClient.h
//  OpenShop
//
//  Created by GusonYang on 16/8/18.
//  Copyright © 2016年 Business-Factory. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface XCAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
