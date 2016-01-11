//
//  TableWeather.h
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/8.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface TableWeather : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    sqlite3 *contactDB;
    NSString *databasePath;
    NSMutableArray *woeidScratch;
    NSString *AddKey;
    NSMutableArray *city;
    NSMutableArray *citywoeid;
    NSMutableArray *nowcode;
    NSMutableArray *nowtemp;
    //int *tablenum;
}
- (void)addwoeid:(NSString *)myString;
@end
