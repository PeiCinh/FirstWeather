//
//  TableWeather.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/8.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//
#define cellhight 90
#define halfwidth 15

#define woeid @"2306181"
#import "TableWeather.h"
#import "WXController.h"
#import "WeatherDate.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "NSObject+YQL.h"
#import "FLAnimatedImage.h"
#import "CoreData/CoreData.h"
#import <sqlite3.h>
#import "AppDelegate.h"
#import "search.h"

@interface TableWeather ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSMutableDictionary *weatheralldate;
@property (nonatomic, strong) UIButton *button;

@end
int tablenum;
@implementation TableWeather
//NSManagedObjectContext *conttext;
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self UpdateWeather];
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    [self overtablecellnum];
    NSLog(@"y = %i",tablenum);
    [self initView];
    [self initbutton];
}

-(void)initView{
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
    //self.tableView.pagingEnabled = YES;//能夠翻轉
    [self.view addSubview:self.tableView];
    
}
- (void)initbutton{
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"+" forState:UIControlStateNormal];
    if (self.view.frame.size.height-(cellhight * [citywoeid count]) < 60) {
        _button.frame = CGRectMake(self.view.frame.size.width-30, (cellhight *tablenum)+15, halfwidth*2, halfwidth*2);
    }else{
        _button.frame = CGRectMake(self.view.frame.size.width-30, (cellhight*citywoeid.count)+15, halfwidth*2, halfwidth*2);
    }
    _button.clipsToBounds = YES;
    
    _button.layer.cornerRadius = halfwidth;//half of the width
    _button.layer.borderColor=[UIColor whiteColor].CGColor;
    _button.layer.borderWidth=1.0f;
    
    //[self.view reloadInputViews];
    [self.view addSubview:_button];
    

}
-(void)ChangeViewAutolayout{
    if (self.view.frame.size.height-(cellhight * [citywoeid count]) < 60) {
        _button.frame = CGRectMake(self.view.frame.size.width-30, (cellhight*tablenum)+15, halfwidth*2, halfwidth*2);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, cellhight*tablenum);
    }else{
        _button.frame = CGRectMake(self.view.frame.size.width-30, (cellhight*citywoeid.count)+15, halfwidth*2, halfwidth*2);
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, cellhight*(citywoeid.count));
        
    }


}
-(void)overtablecellnum{
    int high = _screenHeight;
    if (high % cellhight < cellhight) {
        tablenum = (high / cellhight) -1;
    }else{
        tablenum = high / cellhight;
    }
}
- (void)click{
    search *detailView = [[search alloc]init];
    //透過標簽取得目標實體
    //切換畫面
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:detailView animated:YES completion:nil];
        // [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storyboard animated:YES completion:nil];
    } else {
        [self presentModalViewController:detailView animated:YES];
    }
}
-(void)addwoeid:(NSString *)myString{
    AppDelegate * cell = [AppDelegate new];
    [cell insertCoreData:myString];
    AddKey = [NSString new];
    AddKey = myString;
}
- (void ) UpdateWeather
{
    AppDelegate *call = [AppDelegate new];
    _weatheralldate = [[NSMutableDictionary alloc]init];
    city = [NSMutableArray new];
    nowcode = [NSMutableArray new];
    nowtemp = [NSMutableArray new];
    citywoeid = [NSMutableArray new];
    
    
    _weatheralldate = [ call dataFetchRequest:NULL];
    //NSLog(@"count = %i",_weatheralldate.count);
    for (NSManagedObject *info in _weatheralldate) {
        [city addObject:[info valueForKey:@"city"]];
        [nowcode addObject:[info valueForKey:@"nowcode"]];
        [nowtemp addObject:[info valueForKey:@"nowtemp"]];
        [citywoeid addObject:[info valueForKey:@"woeid"]];
        
    }
    //NSLog(@"city = %@,count = %i",city,[city count] );
    //return WeatherScratch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //NSLog(@"222");
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    if (self.view.frame.size.height-(cellhight * [citywoeid count]) < 60) {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, cellhight*tablenum);
        
    }else{
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, cellhight*(citywoeid.count));
    }
    if (AddKey!=NULL) {
        //[woeidScratch addObject:AddKey];
        AddKey = NULL;
    }

    //self.weatheralldate = [self UpdateWeather:woeidScratch];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    //設定有個ＴＡＢＬＥＢＩＥＷ
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    //return self.weatheralldate.count ;
    return [citywoeid count];
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
        [self DateDailyCell:cell :indexPath.row];
    }
    
    // TODO: Setup the cell
    
    return cell;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return  0;
    }
    //delect tableCell
}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
/*-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSInteger fromRow = [sourceIndexPath row];
    NSInteger toRow = [destinationIndexPath row];
    id obj = [woeidScratch objectAtIndex:fromRow];
    [woeidScratch removeObjectAtIndex:fromRow];
    [woeidScratch insertObject:obj atIndex:toRow];
    [_weatheralldate removeAllObjects];
    //_weatheralldate = [self UpdateWeather:woeidScratch];
}*/
//刪除Table資料
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger num = indexPath.row;
        NSString * deleteString = [citywoeid objectAtIndex:num];

        [citywoeid removeObjectAtIndex:num];
        [city removeObjectAtIndex:num];
        [nowcode removeObjectAtIndex:num];
        [nowtemp removeObjectAtIndex:num];
        AppDelegate *appcall = [AppDelegate new];
        [appcall DeleteCoreData:deleteString];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        [self ChangeViewAutolayout];
        //[self.view reloadInputViews];
        //[self.view r]
        //刪除對應的表格項目
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        //ㄥ- See more at: http://furnacedigital.blogspot.tw/2012/02/uitableview.html#sthash.CmLiSmf8.dpuf
        //[tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)NothingCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}


- (void)DateDailyCell:(UITableViewCell *)cell : (NSInteger *) row{
    WeatherDate * call = [ WeatherDate new];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    cell.textLabel.text = [city objectAtIndex:row] ;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@°",[nowtemp objectAtIndex:row  ]];
    cell.imageView.image = [UIImage imageNamed:[call imageName:[nowcode objectAtIndex:row  ]]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return cellhight ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //利用index取得陣列內的物件
    WXController *detailView =[WXController new];

        [detailView setwoeid:[NSString stringWithFormat:@"%@",[citywoeid objectAtIndex:indexPath.row]]];
  
    //切換畫面
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:detailView animated:YES completion:nil];
        // [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storyboard animated:YES completion:nil];
    } else {
        [self presentModalViewController:detailView animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}
@end
