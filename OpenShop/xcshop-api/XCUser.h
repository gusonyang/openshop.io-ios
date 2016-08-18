//
//  XCUser.h
//  OpenShop
//
//  Created by GusonYang on 16/8/18.
//  Copyright © 2016年 Business-Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCUser : NSObject

@property (strong, nullable) NSNumber *userId;

+ (NSURLSessionDataTask *)login:(NSDictionary *)parameters :(void (^)(id JSON, NSError *error))block;



+ (XCUser *)sharedUser;

+ (BOOL)isLoggedIn;


- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (void)saveUser;

- (void)clearUser;

- (void)logout;

- (void)loginSuccess:(NSDictionary *)response;

@end
