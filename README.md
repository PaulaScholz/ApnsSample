#  APNS Sample

This sample shows how to use the Apple Push Notification service **(APNs)** in your iOS 12 application. To receive notifications, the application must run on an actual iPhone device. You cannot receive notifications on the iOS Simulator.

While the prevelant language standard for iOS development at the time of writing *(April 2019)* is Swift, all code for this tutorial is written in Objective-C.  There are many excellent push notification articles on the web for [Swift](https://www.raywenderlich.com/8164-push-notifications-tutorial-getting-started "Push Notifications Tutorial: Getting Started"), but few comprehensive tutorials written for iOS 12 in Objective-C.

## Prerequisites

To send and receive push notifications for your iOS device, you must:

  * Configure your application and register it with the Apple Push Notification service (APNs).
  * Have an Apple Developer Program membership. To send push notifications from your server you need a push notification certificate for your Apple Developer ID, which requires program membership.
  * Have a server to send push notifications to your device. For this tutorial, we will use the free web-based [pushtry.com](http://pushtry.com "Pushtry notification testing server") server. This free site provides both iOS and Android push notification testing services.

## Configuring your application

To register your application with the Apple Push Notification service, start Safari and go to the [Apple Developer Program site](https://developer.apple.com "Apple Developer Program website").  Sign in with your Apple Developer ID and then click **Account**. You will see a screen like this:

![Account Section](docImages/AppleDevProgamSite.png "Account Section")


```objc
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *strDeviceToken;

@end
```
