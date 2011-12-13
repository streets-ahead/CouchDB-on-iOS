//
//  SAAppDelegate.m
//  couchTest
//
//  Created by sam mussell on 11/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SAAppDelegate.h"

#import <CouchCocoa/CouchDatabase.h>
#import <CouchCocoa/CouchServer.h>
#import <CouchCocoa/RESTOperation.h>
#import <CouchCocoa/CouchDocument.h>

@implementation SAAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CouchbaseMobile* cb = [[CouchbaseMobile alloc] init];
    cb.delegate = self;
    NSAssert([cb start], @"Couchbase didn't start! Error = %@", cb.error);
    
    return YES;
}

- (void)createDocumentInDatabase:(CouchDatabase*)db {
    CouchDocument* doc = [db untitledDocument];
    RESTOperation* op = [doc putProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"Women Be", @"mykey1",
                                                                                    @"Stoppin", @"mykey2", nil]];
    // make a synchronous call
    BOOL wasCreated = [op wait];
    NSLog(@"DOCUMENT CREATED PLAYA %d", wasCreated);
}

- (void)couchbaseMobile:(CouchbaseMobile *)couchbase didStart:(NSURL *)serverURL {
    NSLog(@"SUCCESS");
    
    
    CouchServer* server = [[CouchServer alloc] initWithURL:serverURL];
    CouchDatabase* db = [server databaseNamed:@"mydb"];
    
    // make asynchronous call
    RESTOperation* op = [db create];
    [op onCompletion:^{
        NSLog(@"DB CREATED FOOL!");
        [self createDocumentInDatabase:db];
    }];
    [op start];
}

- (void)couchbaseMobile:(CouchbaseMobile *)couchbase failedToStart:(NSError *)error {
    NSLog(@"An error occurred, %@", [error localizedDescription]);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
