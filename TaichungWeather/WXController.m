//
//  WXController.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//
#define Query @"2306181"
#import "WXController.h"
#import "WeatherDate.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "NSObject+YQL.h"
#import "FLAnimatedImage.h"
#import "TableWeather.h"
#import "AppDelegate.h"
@interface WXController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat screenwidth;
@property (nonatomic, strong) NSMutableDictionary *weatheralldate;
@end

@implementation WXController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewwork");
    //YQL * yql = [YQL new];
    AppDelegate *appdelegatecell = [AppDelegate new];
    WeatherDate *call = [WeatherDate new];
    [appdelegatecell yesnofirstopen];
    
    _weatheralldate =NULL;
    //NSMutableDictionary * a ;
    if (WoeidKey !=NULL) {
        _weatheralldate = [appdelegatecell dataFetchRequest: WoeidKey];
        WoeidKey = NULL;
    }else{
        _weatheralldate = [appdelegatecell dataFetchRequest: Query];
    }
    
    dailyday = [NSMutableArray new];
    dailycode = [NSMutableArray new];
    dailyhigh = [NSMutableArray new];
    dailylow = [NSMutableArray new];
    for (int i =1; i<=5; i++) {
        [dailyday addObject:[_weatheralldate valueForKeyPath:[NSString stringWithFormat:@"day%i",i]]];
        [dailycode addObject:[_weatheralldate valueForKeyPath:[NSString stringWithFormat:@"code%i",i]]];
        [dailyhigh addObject:[_weatheralldate valueForKeyPath:[NSString stringWithFormat:@"high%i",i]]];
        [dailylow addObject:[_weatheralldate valueForKeyPath:[NSString stringWithFormat:@"low%i",i]]];
        
    }
    self.screenwidth  = [UIScreen mainScreen].bounds.size.width;
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"high = %f",self.screenHeight);
    [self initView];
    [self initUI];
    
}
- (void)initView{
    UIImage *background = [UIImage imageNamed:@"bg"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;//能夠翻轉
    [self.view addSubview:self.tableView];
    

}
- (void)initUI
{
    WeatherDate *call = [WeatherDate new];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    CGFloat Iphone5shigh = 568;
    CGFloat Iphone5swidth ;
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - (hiloHeight), headerFrame.size.width - 2*inset, hiloHeight);
    CGRect temperatureFrame = CGRectMake(inset-20, headerFrame.size.height - temperatureHeight - hiloHeight, headerFrame.size.width - 2*inset, temperatureHeight);
    CGRect sunriseFrame = CGRectMake(headerFrame.size.width-150, headerFrame.size.height - hiloHeight, headerFrame.size.width - 2*inset, hiloHeight);
    CGRect sunsetFrame = CGRectMake((headerFrame.size.width-100)*_screenwidth/Iphone5swidth, headerFrame.size.height - temperatureHeight - hiloHeight, 100, temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    CGRect conditionsFrame = iconFrame;
    // make the conditions text a little smaller than the view
    // and to the right of our icon
    conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
    conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    // nowtemp
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    //temperatureLabel.text = [NSString stringWithFormat:@"%@°",[self.weatheralldate valueForKeyPath:[call JSONKey:@"newtemp"]]];
    temperatureLabel.text = [NSString stringWithFormat:@"%@°",[ _weatheralldate valueForKeyPath:@"nowtemp"]];
    temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:temperatureLabel];
    
    // temphigh/low
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = [NSString stringWithFormat:@"%@° / %@°",[self.weatheralldate valueForKeyPath:@"high1" ],[self.weatheralldate valueForKeyPath:@"low1" ]];
    hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:hiloLabel];
    
    // cityname
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 50)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    //cityLabel.text = [NSString stringWithFormat:@"%@",[self.weatheralldate valueForKeyPath:[call JSONKey:@"city"]]];
    cityLabel.text = [NSString stringWithFormat:@"%@",[_weatheralldate valueForKey:@"city"]];
    cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:38];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:conditionsLabel];
    
    // bottom left
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:iconView];
    
    
    // newcode
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@2x",[call imageName:[_weatheralldate valueForKey:@"nowcode"]]]]];
    imgView.frame=sunsetFrame;
    
    [header addSubview:imgView];
    // sunset/rise
    
    UILabel *sunrise = [[UILabel alloc] initWithFrame:sunriseFrame];
    sunrise.backgroundColor = [UIColor clearColor];
    sunrise.textColor = [UIColor whiteColor];
    
    //sunrise.text = [NSString stringWithFormat:@"↑%@ / ↓%@",[self.weatheralldate valueForKeyPath:[call JSONKey:@"sunrise"]],[self.weatheralldate valueForKeyPath:[call JSONKey:@"sunset"]]];
    sunrise.text = [NSString stringWithFormat:@"↑%@ / ↓%@",[self.weatheralldate valueForKeyPath:@"sunrise"],[self.weatheralldate valueForKeyPath:@"sunrise"]];
    sunrise.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [header addSubview:sunrise];
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _menuButton.frame = CGRectMake(10, 30, 30, 30);
    [_menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [_menuButton addTarget:self action:@selector(goweathertable) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:_menuButton];

}
-(void)setwoeid:(NSString *)string{
    WoeidKey = string;
}
- (void)goweathertable{
    TableWeather *detailView = [[TableWeather alloc]init];
    //透過標簽取得目標實體
    //切換畫面
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:detailView animated:YES completion:nil];
       // [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storyboard animated:YES completion:nil];
    } else {
        [self presentModalViewController:detailView animated:YES];
    }
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
   
}

/*- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}*/



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    //設定有個ＴＡＢＬＥＢＩＥＷ
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    return 5 + 1;
    //設定有幾個ＴＡＢＬＥＶＩＥＷＣＥＬＬ
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    //[self NothingCell: cell title:@"Hourly Forecast"];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self NothingCell: cell title:@"Daily Forecast"];
        }
        else {
           
            [self DateDailyCell:cell : indexPath.row];
        }
    }

    // TODO: Setup the cell
    
    return cell;
}

- (void)NothingCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}


- (void)DateDailyCell:(UITableViewCell *)cell :(int *)row{
    WeatherDate * call = [ WeatherDate new];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    int num = row ;
    num-=1;
    cell.textLabel.text = [dailyday objectAtIndex:num];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@° / %@°",[dailyhigh objectAtIndex:num],[dailylow objectAtIndex:num]];
    cell.imageView.image = [UIImage imageNamed:[ call imageName:[dailycode objectAtIndex:num]   ]];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@° / %@°",[[Date valueForKeyPath:[call JSONKey:@"high"]]objectAtIndex:index],[[Date valueForKeyPath:[call JSONKey:@"low"]]objectAtIndex:index]];
    //cell.imageView.image = [UIImage imageNamed:[call imageName:[[Date valueForKeyPath:[call JSONKey:@"daiycode"]]objectAtIndex:index]]];
    //cell.imageView.image = [UIImage imageNamed:@"weather-few-night"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}


@end
