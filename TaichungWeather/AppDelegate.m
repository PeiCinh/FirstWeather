//
//  AppDelegate.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//
#define BasicWoeid @"2306181"
#import "AppDelegate.h"
#import "WXController.h"
#import <TSMessage.h>
#import <sqlite3.h>
#import "TableWeather.h"
#import "NSObject+YQL.h"
#import "WeatherDate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[WXController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [TSMessage setDefaultViewController: self.window.rootViewController];

   //NSMutableArray *a = [self dataFetchRequest];
    //[self dataFetchRequest1];
    //NSMutableDictionary *a = [self dataFetchRequest:NULL];
    //NSMutableArray *B= [self dataFetchRequest:@"2306179"];
    return YES;
}
// https://disp.cc/b/11-88Jy
- (void)yesnofirstopen{
    ////NSLog(@"First Work Core Date");
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        [self insertCoreData:BasicWoeid];
        //NSLog(@"Firstwork");
    }else{
        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(coredataupdate) userInfo:nil repeats:YES];
        [self coredataupdate];
    }

}
- (void)coredataupdate{
    NSLog(@"time");
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Weather" inManagedObjectContext:context]];
    NSError *error;
    //更新谁的条件在这里配置；
    //NSString *theName = @"uptest";
    //------------------------------------------------------------------------------------
    id update;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        update = [self dataFetchRequest:[info valueForKeyPath:@"woeid"]];
        //NSLog(@"update = %@",update);
        [info setValue:[update valueForKeyPath:@"nowcode"] forKey:@"nowcode"];
        [info setValue:[update valueForKeyPath:@"nowtemp"] forKey:@"nowtemp"];
        [info setValue:[update valueForKeyPath:@"sunrise"] forKey:@"sunrise"];
        [info setValue:[update valueForKeyPath:@"sunset"] forKey:@"sunset"];
        for (int i = 1; i<=5; i++) {
            [info setValue:[update valueForKeyPath:[NSString stringWithFormat:@"day%i",i]] forKey:[NSString stringWithFormat:@"day%i",i]];
            [info setValue:[update valueForKeyPath:[NSString stringWithFormat:@"code%i",i]] forKey:[NSString stringWithFormat:@"code%i",i]];
            [info setValue:[update valueForKeyPath:[NSString stringWithFormat:@"high%i",i]] forKey:[NSString stringWithFormat:@"high%i",i]];
            [info setValue:[update valueForKeyPath:[NSString stringWithFormat:@"low%i",i]] forKey:[NSString stringWithFormat:@"low%i",i]];
        }
    }
    [context save:nil];
    //------------------------------------------------------------------------------------
    //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"woeid==" ]];
    
    //------------------------------------------------------------------------------------
    
}
- (void)insertCoreData: (NSString *)updatewoeid
{
    ////NSLog(@"UpdateWoeid = %@",updatewoeid);
    YQL *yql = [YQL new];
    WeatherDate *cell  = [WeatherDate new];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
    NSMutableDictionary * Scratch = [yql query:updatewoeid];
    
    [contactInfo setValue:updatewoeid forKey:@"woeid"];
    [contactInfo setValue:[Scratch valueForKeyPath:[cell JSONKey:@"city"]] forKey:@"city"];
    [contactInfo setValue:[Scratch valueForKeyPath:[cell JSONKey:@"newcode"]] forKey:@"nowcode"];
    [contactInfo setValue:[Scratch valueForKeyPath:[cell JSONKey:@"newtemp"]] forKey:@"nowtemp"];
    [contactInfo setValue:[Scratch valueForKeyPath:[cell JSONKey:@"sunrise"]] forKey:@"sunrise"];
    [contactInfo setValue:[Scratch valueForKeyPath:[cell JSONKey:@"sunset"]] forKey:@"sunset"];
    for (int i = 1; i<=5; i++) {
        [contactInfo setValue:[[Scratch valueForKeyPath:[cell JSONKey:@"high"]]objectAtIndex:i-1] forKey:[NSString stringWithFormat:@"high%i",i]];
        [contactInfo setValue:[[Scratch valueForKeyPath:[cell JSONKey:@"low"]]objectAtIndex:i-1] forKey:[NSString stringWithFormat:@"low%i",i]];
        [contactInfo setValue:[[Scratch valueForKeyPath:[cell JSONKey:@"day"]]objectAtIndex:i-1] forKey:[NSString stringWithFormat:@"day%i",i]];
        [contactInfo setValue:[[Scratch valueForKeyPath:[cell JSONKey:@"daiycode"]]objectAtIndex:i-1] forKey:[NSString stringWithFormat:@"code%i",i]];
    }
    NSError *error;
    if(![context save:&error])
    {
        //NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}
- (NSMutableDictionary *)dataFetchRequest : (NSString *)String
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Weather" inManagedObjectContext:context]];
    NSError *error;
    //更新谁的条件在这里配置；
    //NSString *theName = @"uptest";
    if (String !=NULL) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"woeid==%@", String]];
    }
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

    //NSMutableDictionary *RequestInfo = [NSMutableDictionary new];

    id qq = [fetchedObjects valueForKey:@"city"];
    NSManagedObject *bb = (NSManagedObject *)fetchedObjects;
    for (NSManagedObject *info in fetchedObjects) {
  
        qq = info;
    }
    if (String !=NULL) {
        return qq;
    }else{
        return bb;//[fetchedObjects valueForKey:@"woeid"];
    }
}
- (void)DeleteCoreData:(NSString *)row{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Weather" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"woeid==%@", row]];
    
    NSError* error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    NSManagedObject *delectdata = results[0];
    [context deleteObject:delectdata];
    [context save:nil];
}
- (void)dataFetchRequest1
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Weather" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    //NSLog(@"array = %@,%i",fetchedObjects,[fetchedObjects count]);
    ////NSLog(@"11 = %@,",[fetchedObjects objectAtIndex:0]);
    for (NSManagedObject *info in fetchedObjects) {
        //NSLog(@"info = %@",info);
        //NSLog(@"woeid:%@", [info valueForKey:@"woeid"]);
        //NSLog(@"city:%@", [info valueForKey:@"city"]);
        //NSLog(@"nowcode:%@", [info valueForKey:@"nowcode"]);
        //NSLog(@"nowtemp:%@", [info valueForKey:@"nowtemp"]);
        //NSLog(@"sunrise:%@", [info valueForKey:@"sunrise"]);
        //NSLog(@"sunset:%@", [info valueForKey:@"sunset"]);
        for (int i = 1; i <=5; i++) {
            //NSLog(@"day%i:%@",i, [info valueForKey:[NSString stringWithFormat:@"day%i",i]]);
            //NSLog(@"code%i:%@",i, [info valueForKey:[NSString stringWithFormat:@"code%i",i]]);
            //NSLog(@"high%i:%@",i, [info valueForKey:[NSString stringWithFormat:@"high%i",i]]);
            //NSLog(@"low%i:%@",i, [info valueForKey:[NSString stringWithFormat:@"low%i",i]]);
        }
    }
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Huang201601.CoreDate_Demo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Weather" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Weather.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
