//
//  AppDelegate.h
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <sqlite3.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    sqlite3 *contactDB;
    NSString *databasePath;
}

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)insertCoreData: (NSString *)updatewoeid;
- (NSMutableDictionary *)dataFetchRequest : (NSString *)String;
- (void)DeleteCoreData: (NSString *)row;
- (void)yesnofirstopen;
@end

