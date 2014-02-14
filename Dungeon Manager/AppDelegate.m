//
//  AppDelegate.m
//  Dungeon Manager
//
//  Created by Andrew Rodgers on 1/30/14.
//  Copyright (c) 2014 EnhanceDailyLife. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.mainController = (UINavigationController*)  self.window.rootViewController;
	self.pressThreeFingers = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
	self.pressThreeFingers.numberOfTouchesRequired = 3;
	self.pressThreeFingers.minimumPressDuration = 0.5;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableTouches) name:@"ReenableTouches" object:nil];
	[self enableTouches];

    return YES;
}
													   
-(void)tapScreen
{
	[self.window removeGestureRecognizer:self.pressThreeFingers];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		[self.mainController pushViewController:[[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"diceController"] animated:YES];
	}
	else
	{
		[self.mainController pushViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"diceController"] animated:YES];
	}
}

-(void)enableTouches
{
	[self.window addGestureRecognizer:self.pressThreeFingers];
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
