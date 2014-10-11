//
//  AppDelegate.m
//  sfHackVT
//
//  Created by Joshua Barry on 10/10/14.
//
//

#import "AppDelegate.h"

#import "NetworkingController.h"
#import "CoreDataController.h"
#import "MainViewController.h"
#import "MainNavigationController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Version: %@",APP_VERSION);
    NSLog(@"Last Updated: %@",APP_LAST_UPDATE);
    
    // User found in CoreData, load questions from server and send to Welcome screen.
    // Grab Questions from Server if a user is found in CoreData.
    [[NetworkingController sharedNetworkingController] getDataFromServer];
    // Create our initial view Controller.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainViewController *view = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    MainNavigationController *navy = [[MainNavigationController alloc] initWithRootViewController:view];
    // Remove our sneaky Navigation bar..
    [navy setNavigationBarHidden:TRUE];
    self.window.rootViewController = navy;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[CoreDataController sharedInstance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreDataController sharedInstance] saveContext];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

