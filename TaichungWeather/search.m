//
//  search.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/9.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import "search.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "NSObject+YQL.h"
#import "TableWeather.h"
@interface search ()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *SearchUi;
@property (nonatomic, strong) UIView *header;
//@property (nonatomic, strong) UISearchDisplayController *searchBarController;
@end

@implementation search

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    DateCount = 0;
    //NSLog(@"111 = %i",DateCount);
    CGRect headerFrame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    _header = [[UIView alloc] initWithFrame:headerFrame];
    _header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = _header;
    
    [self initNav];
    [self initSearchBar];
    
}

-(void)initNav{
    //狀態列的背景颜色
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,60)];
    navLabel.backgroundColor = [UIColor blackColor];
    //navLabel.textColor = RGBACOLOR(11, 104, 210, 1);
    navLabel.textColor = [UIColor whiteColor];
    navLabel.text = @"輸入城市";
    navLabel.font = [UIFont systemFontOfSize:18];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.userInteractionEnabled = YES;
    [_header addSubview:navLabel];
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
-(void)initSearchBar{
    // Do any additional setup after loading the view.
    
    _SearchUi = [[UISearchBar alloc]initWithFrame:CGRectMake(0,60,self.view.frame.size.width,40)];
    //SearchUi.text= @"DOT";
    [_SearchUi setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_SearchUi sizeToFit];
    
    _SearchUi.placeholder =@"請输入要搜索的詞語";
    _SearchUi.tintColor = [UIColor whiteColor];
    _SearchUi.barTintColor = [UIColor redColor];
    self.SearchUi.delegate = self;
    // 除搜索栏框框,就像贴了一张镂空了搜索栏的颜色贴图,不影响其他任何设置的颜色
    _SearchUi.barTintColor = [UIColor blackColor];
    
    [_SearchUi setShowsCancelButton:YES animated:YES];
    // 搜索结果按钮是否被选中
    [_header addSubview:_SearchUi];
    
    /* _searchBarController = [[UISearchDisplayController alloc] initWithSearchBar:_SearchUi contentsController:self];
     _searchBarController.delegate = self;
     _searchBarController.searchResultsDataSource = self;
     _searchBarController.searchResultsDelegate = self;*/
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    //設定有個ＴＡＢＬＥＢＩＥＷ
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    /*if (SearchDate!=NULL) {
        
        if (OneDate) {
            return 1;
        }else{
            return [SearchDate count];
        }
    }else{
        return 0;
    }*/
    return DateCount;
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
    
    // if (tableView == _searchBarController.searchResultsTableView) {
    if (indexPath.section == 0) {
        [self DateCell:cell :SearchDate :indexPath.row];
    }
    //}
    return cell;
}

- (void)NothingCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}


- (void)DateCell:(UITableViewCell *)cell : (NSMutableArray *)Date :(NSInteger *)row{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    //cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:30];
    if (DateCount==1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",[Date valueForKey:@"name"], [Date valueForKey:@"country"]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",[[Date valueForKeyPath:@"name"]objectAtIndex:row  ], [[Date valueForKeyPath:@"country"]objectAtIndex:row  ]];
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //利用index取得陣列內的物件
    TableWeather *detailView =[TableWeather new];
    if (DateCount == 1) {
        [detailView addwoeid:[NSString stringWithFormat:@"%@",[SearchDate valueForKey:@"woeid"]]];
    }else{
        [detailView addwoeid:[NSString stringWithFormat:@"%@",[[SearchDate valueForKey:@"woeid"]objectAtIndex:indexPath.row]]];
    }
    //切換畫面
    /*if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:detailView animated:YES completion:nil];
        // [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storyboard animated:YES completion:nil];
    } else {
        [self presentModalViewController:detailView animated:YES];
    }*/
    [self searchBarCancelButtonClicked:self.SearchUi];
    
}

#pragma mark - UIScrollViewDelegate

- (void)searchWeatherList {
    YQL *yql = [YQL new];
    NSMutableDictionary *JsonAllDate = [yql querywhere:_SearchUi.text];
    ////NSLog(@"jsondate= %@",JsonAllDate);
    DateCount = [[JsonAllDate valueForKeyPath:@"query.count"]integerValue];
   
    SearchDate= [JsonAllDate valueForKeyPath:@"query.results.place"];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if([searchText length] != 0) {
        [self searchWeatherList];
    }else{
        SearchDate = nil;
        DateCount = 0;
    }
    [_tableView reloadData]; //重新刷新ＴＡＢＬＥ數據
}

//searchBar开始编辑时改变取消按钮的文字
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //_SearchUi.showsCancelButton = YES;
    ////NSLog(@"1");
    for (UIView *subView in _SearchUi.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            //NSLog(@"2");
            UIButton *cancelButton = (UIButton*)subView;
            
            [cancelButton setEnabled:YES];
            [cancelButton setTitle:@"Cancel1" forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"button-green"] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:[UIImage imageNamed:@"button-green-highlight"] forState:UIControlStateHighlighted];
            
        }
    }
    _SearchUi.autocorrectionType = UITextAutocorrectionTypeNo;
    
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    TableWeather *detailView =[TableWeather new];
    //切換畫面
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
        [self presentViewController:detailView animated:YES completion:nil];
        // [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:storyboard animated:YES completion:nil];
    } else {
        [self presentModalViewController:detailView animated:YES];
    }

}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    /*[UIView animateWithDuration:1.0 animations:^{
     _tableView.frame = CGRectMake(0, is_IOS_7?64:44, self.view.frame.size.width, self.view.frame.size.height-64);
     }];*/
    
    return YES;
}


@end
