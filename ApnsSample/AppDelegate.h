//
//  AppDelegate.h
//  ApnsSample
//
//  Created by Paula Scholz on 4/9/19.
//  Copyright © 2019 Paula Scholz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *strDeviceToken;

@end

