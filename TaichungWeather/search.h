//
//  search.h
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/9.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface search : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UISearchResultsUpdating>{
    NSMutableDictionary * SearchDate;
    NSInteger *DateCount;
    //BOOL * OneDate;
}

@end
