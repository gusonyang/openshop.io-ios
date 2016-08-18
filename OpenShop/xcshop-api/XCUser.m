//
//  XCUser.m
//  OpenShop
//
//  Created by GusonYang on 16/8/18.
//  Copyright © 2016年 Business-Factory. All rights reserved.
//

#import "XCUser.h"
#import "XCAPIClient.h"
#import "NSNotificationCenter+BFAsyncNotifications.h"
#import "NSNotificationCenter+BFManagedNotificationObserver.h"

static NSString *const XCUserDefaultsUserKey                           = @"XCUser";

@implementation XCUser

+ (NSURLSessionDataTask *)login:(NSDictionary *)parameters :(void (^)(id JSON, NSError *error))block {
    return [[XCAPIClient sharedClient] POST:@"/api/public/v1/user/login" parameters:parameters progress:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        if (block) {
            block(JSON, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        if (block) {
            block(NO, error);
        }
    }];
}



+ (XCUser *)sharedUser {
    static XCUser *sharedUser = nil;
    @synchronized(self)
    {
        if (sharedUser == nil)
        {
            NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:XCUserDefaultsUserKey];
            if (data != nil)
            {
                sharedUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (sharedUser == nil)
                {
                    sharedUser = [[self alloc] init];
                }
                
            } else {
                sharedUser = [[self alloc] init];
            }
        }
    }
    return sharedUser;
}

+ (BOOL)isLoggedIn {
    return [XCUser sharedUser].userId != nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self)
    {
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.userId forKey:@"userId"];
}

- (void)saveUser {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:XCUserDefaultsUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFUserDidSaveNotification];
}

- (void)clearUser {
    self.userId = nil;
    [self saveUser];
}

- (void)logout {
    // clean up
    [self clearUser];
    // notify with changes
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFCartWillSynchronizeNotification];
        [[NSNotificationCenter defaultCenter] BFN_postAsyncNotificationName:BFUserDidChangeNotification];
    });
}

- (void)loginSuccess:(NSDictionary *)response {
    XCUser *user = [XCUser sharedUser];
    user.userId = [response objectForKey:@"id"];
    [user saveUser];
}

@end
