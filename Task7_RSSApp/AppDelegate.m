//
//  AppDelegate.m
//  Task7_RSSApp
//
//  Created by Anton Kushnerov on 4.07.21.
//

#import "AppDelegate.h"
#import "AutorizationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    AutorizationViewController *rootVIewController = [[AutorizationViewController alloc] initWithNibName:@"AutorizationViewController" bundle:nil];
    [window setRootViewController:rootVIewController];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}




@end
