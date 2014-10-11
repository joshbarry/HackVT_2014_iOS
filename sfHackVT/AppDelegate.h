//
//  AppDelegate.h
//  sfHackVT
//
//  Created by Joshua Barry on 10/10/14.
//
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#define APP_VERSION @"1.0.0"
#define APP_LAST_UPDATE @"October 10th, 2014."

- (NSURL *)applicationDocumentsDirectory;

@end


