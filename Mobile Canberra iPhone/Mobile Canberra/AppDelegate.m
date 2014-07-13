//
//  AppDelegate.m
//  Mobile Canberra
//
//  Created by Zaki Bouguettaya on 16/09/13.
//  Copyright (c) 2013 Imagine Team. All rights reserved.
//

#import "AppDelegate.h"
#import "ParallaxViewController.h"
#import "DataSetListElement.h"
#import "MapViewController.h"

#define PKWaitDelay(dly, block)     dispatch_after(dispatch_time(DISPATCH_TIME_NOW,dly*100000),dispatch_get_current_queue(), ^{ block })

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ParallaxViewController alloc] initWithNibName:@"ParallaxViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
   
    [self.window makeKeyAndVisible];
    
	if ( [self returnAppRunCount] == 0 ) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];        
	}
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self incrementAppRunCount];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    // Check the notification
    if ([[notification.userInfo objectForKey:@"identifier"] isEqualToString:@"relic"]) {
        
        NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"GetListOfDatasets" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonFilePath];
        NSError *error;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSMutableArray *datasets = [[NSMutableArray alloc] init];
        NSMutableArray *originaldatasets = [[NSMutableArray alloc] init];
        
        NSNumber *success = [jsonDict objectForKey:@"success"];
        if ([success integerValue]==1){
            NSArray *listOfDatasets = [jsonDict objectForKey:@"listOfDatasets"];
            for (int i=0;i<listOfDatasets.count;i++){
                NSDictionary *dataobject = [listOfDatasets objectAtIndex:i];
                DataSetListElement *dataset = [[DataSetListElement alloc] init];
                [dataset initWithName:[dataobject objectForKey:@"name"] andColor:[dataobject objectForKey:@"color"] andId:[dataobject objectForKey:@"id"]];
                [datasets addObject:dataset];
                [originaldatasets addObject:dataset];
            }
            
            MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            DataSetListElement *dataset = [datasets objectAtIndex:6];
            mapViewController.clickedDataset = dataset;
            mapViewController.datasets = datasets;
            mapViewController.blockAlerts = YES;
           
            // Quite possibly the most dodgy bit of coding ever done in a hackathon...
            // For demo only, don't expect this to work very well once it's been presented :)
            self.window.rootViewController = mapViewController;
            
            mapViewController.popupHolder.hidden = NO;
            [mapViewController.view bringSubviewToFront:mapViewController.popupHolder];
            mapViewController.popupTitle.text = @"Relic";
            mapViewController.pointDetails.text = @"Relic is a bronze sentinal, an ancient figure borne from distant memory, standing at a nexus of both time and place. Located at the edge of the city and watching over a seat of learning, the sculpture evokes both power and purpose. Relic was the winner of the prestigious McClelland Sculpture Prize in 2007.";
            [mapViewController.popupBk setImage: [UIImage imageNamed:@"bluelargepinbk"]];
            [mapViewController.popupClose setImage:[UIImage imageNamed:@"closemarkerbluebtn"] forState:UIControlStateNormal];
            [mapViewController.popupDirections setImage:[UIImage imageNamed:@"bluetakemetherebtn"] forState:UIControlStateNormal];
            
        }
    
    }
    
}


#pragma mark -
#pragma mark app run count


// -------------------------------------
// * Returns the run count for the app *
// -------------------------------------

- (int)returnAppRunCount {
    
	// Get the defaults for the app
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Convert the run count (stored as a NSString into an integer)
	int runCount = [[defaults objectForKey:@"appRunCount"] intValue];
    
	// Return the run count
	return runCount;
	
}


// ---------------------------------------
// * Increment the run count for the app *
// ---------------------------------------

- (void)incrementAppRunCount {
    
	// Get the defaults for the app
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	// Convert the run count (stored as a NSString into an integer)
	int runCount = [[defaults objectForKey:@"appRunCount"] intValue];
    
	// Increment and update the run count
	[defaults setObject:[NSString stringWithFormat:@"%i", (runCount + 1)] forKey:@"appRunCount"];
	
	// Save the defaults
	[defaults synchronize];
	
}

@end
