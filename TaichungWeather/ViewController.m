//
//  ViewController.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+YQL.h"
#import "WXController.h"
#import "AppDelegate.h"
#import <TSMessage.h>
@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    YQL * yql = [YQL new];
    NSString *Query = @"select%20*%20from%20weather.forecast%20where%20woeid%20%3D%202306181";
    NSDictionary *weatherDic = [yql query:Query];
    NSLog(@"22 = %@",[[weatherDic valueForKeyPath:@"query.results.channel.item"] description]);
     //self.view.backgroundColor = [UIColor redColor];


    // Do any additional setup after loading the view, typically from a nib.
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"yweather:condition"]) {
        
        NSLog(@"Today's weather is %@",[attributeDict objectForKey:@"text"]);
        
    }
    NSLog(@"xml = %@",elementName);
}
/*
 
 $.getJSON('https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%202306180&format=json&callback=?', function(json) {
 var w_code = weather_con[json.query.results.channel.item.condition.code.toString()];
 var w_temp = Math.round((json.query.results.channel.item.condition.temp - 32)*5/9) + "℃";
 console.log(w_code);
 console.log(w_temp);
 });
 
 //這個我翻得可能不是很標準...
 weather_con = {
 "0":"龍捲風",
 "1":"熱帶風暴",
 "2":"颶風",
 "3":"強雷陣雨",
 "4":"雷陣雨",
 "5":"混合雨雪",
 "6":"混合雨雪",
 "7":"混合雨雪",
 "8":"冰凍小雨",
 "9":"細雨",
 "10":"凍雨",
 "11":"陣雨",
 "12":"陣雨",
 "13":"飄雪",
 "14":"陣雪",
 "15":"吹雪",
 "16":"下雪",
 "17":"冰雹",
 "18":"雨雪",
 "19":"多塵",
 "20":"多霧",
 "21":"陰霾",
 "22":"多煙",
 "23":"狂風大作",
 "24":"有風",
 "25":"冷",
 "26":"多雲",
 "27":"晴間多雲（夜）",
 "28":"晴間多雲（日）",
 "29":"晴間多雲（夜）",
 "30":"晴間多雲（日）",
 "31":"清晰的（夜）",
 "32":"晴朗",
 "33":"晴朗（夜）",
 "34":"晴朗（日）",
 "35":"雨和冰雹",
 "36":"炎熱",
 "37":"雷陣雨",
 "38":"零星雷陣雨",
 "39":"零星雷陣雨",
 "40":"零星雷陣雨",
 "41":"大雪",
 "42":"零星陣雪",
 "43":"大雪",
 "44":"多雲",
 "45":"雷陣雨",
 "46":"陣雪",
 "47":"雷陣雨",
 "3200":"資料錯誤"
 };
 
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
