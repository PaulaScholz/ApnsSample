//
//  AppDelegate.m
//  ApnsSample
//
//  Created by Paula Scholz on 4/9/19.
//  Copyright © 2019 Paula Scholz. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"inside didFinishLaunchingWithOptions");

    // execute on main thread only
    dispatch_async(dispatch_get_main_queue(), ^{
        [self registerForRemoteNotifications];
    });
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark This is the start of the User Notification code

// this must be called from the main thread
- (void)registerForRemoteNotifications {
    
    NSLog(@"inside registerForRemoteNotifications");
    
    // UserNotifications are available in iOS 10 and above
    if(@available(iOS 10,*)){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                NSLog(@"registerd for remote notifications");
                
                // execute on main thread only
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
                
            }
            else
            {
                
                NSLog(@"error in notification registration : %@", [error localizedDescription]);            }
        }];
    }
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    
    [self handleRemoteNotification:[UIApplication sharedApplication] userInfo:notification.request.content.userInfo];
}

// if the user presses on the notification while the app is in background, launch the content in the passed URL in Safari
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    
    // The method will be called on the delegate when the user responded to the notification by opening the application,
    // dismissing the notification or choosing a UNNotificationAction.
    // The delegate must be set before the application returns from applicationDidFinishLaunching:.
    
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    
    [self handleRemoteNotification:[UIApplication sharedApplication] userInfo:response.notification.request.content.userInfo];
}

// If we did successfully register for device notifications, get our device token and put it on the debug console
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *strDevicetoken = [[NSString alloc]initWithFormat:@"%@",[[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSLog(@"Device Token = %@",strDevicetoken);
    
    self.strDeviceToken = strDevicetoken;
}

// If we did not successfully register for device notifictions, log the error on the debug console
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@ = %@", NSStringFromSelector(_cmd), error);
    NSLog(@"Error = %@",error);
}

// Process the remote notification contents, grab the sent URL, and launch Safari with that URL
-(void) handleRemoteNotification:(UIApplication *) application userInfo:(NSDictionary *) remoteNotif {
    
    NSLog(@"handleRemoteNotification Dictionary: %@", remoteNotif);
    
    // get the dictionary of values from the notification
    NSDictionary* aps = [remoteNotif valueForKey:@"aps"];
    
    // get the linkURL string from the aps Dictionary
    NSString* linkURL = [[NSString alloc] initWithString:[aps valueForKey:@"linkURL"]];
    
    NSLog(@"linkURL: %@", linkURL);
    
    // if we got a linkURL element in the JSON, launch Safari with the URL
    if(linkURL){
        
        // convert the string to an actual URL
        NSURL* url =[NSURL URLWithString:[linkURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        // launch Safari with the URL
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

@end
