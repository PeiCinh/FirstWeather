//
//  WXController.h
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDate.h"
@interface WXController : UIViewController
<UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate, UIViewControllerPreviewingDelegate,UIViewControllerTransitioningDelegate>{
        UIButton            *_menuButton;
    NSString  *WoeidKey;
    NSMutableArray *dailyday;
    NSMutableArray *dailycode;
    NSMutableArray *dailyhigh;
    NSMutableArray *dailylow;
}
-(void)setwoeid:(NSString *)string;
@end
