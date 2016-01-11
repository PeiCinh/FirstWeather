//
//  WeatherDate.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/8.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import "WeatherDate.h"

@implementation WeatherDate


- (NSString *)imageName: (NSString *)icon{
    return [[WeatherDate imageMap] valueForKey:icon ];
}
- (NSString *)JSONKey: (NSString *)key{
    return [[WeatherDate JSONMap] valueForKey:key ];
}
+ (NSDictionary *)imageMap {
    NSDictionary *imageCode = nil;
    if (! imageCode) {
        imageCode = @{
                      @"1" : @"weather-shower",
                      @"2" : @"weather-shower",
                      @"3" : @"weather-shower",
                      @"4" : @"weather-shower",
                      @"5" : @"weather-shower",
                      @"6" : @"weather-rain",
                      @"7" : @"weather-tstorm",
                      @"8" : @"weather-rain",
                      @"9" : @"weather-rain",
                      @"10" : @"weather-rain",
                      @"11" : @"weather-rain",
                      @"12" : @"weather-rain",
                      @"13" : @"weather-snow",
                      @"14" : @"weather-snow",
                      @"15" : @"weather-snow",
                      @"16" : @"weather-snow",
                      @"17" : @"weather-snow",
                      @"18" : @"weather-snow",
                      @"19" : @"weather-mist",
                      @"20" : @"weather-mist",
                      @"21" : @"weather-mist",
                      @"22" : @"weather-few",
                      @"23" : @"weather-few",
                      @"24" : @"weather-broken",
                      @"25" : @"weather-shower",
                      @"26" : @"weather-broken",
                      @"27" : @"weather-few-night",
                      @"28" : @"weather-few",
                      @"29" : @"weather-few-night",
                      @"30" : @"weather-few",
                      @"31" : @"weather-moon",
                      @"32" : @"weather-clear",
                      @"33" : @"weather-moon",
                      @"34" : @"weather-clear",
                      @"35" : @"weather-shower",
                      @"36" : @"weather-clear",
                      @"37" : @"weather-rain",
                      @"38" : @"weather-rain",
                      @"39" : @"weather-rain",
                      @"40" : @"weather-rain",
                      @"41" : @"weather-snow",
                      @"42" : @"weather-few",
                      @"43" : @"weather-snow",
                      @"44" : @"weather-broken",
                      @"45" : @"weather-rain",
                      @"46" : @"weather-snow",
                      @"47" : @"weather-rain",
                      };
    }
    return imageCode;
}
+ (NSDictionary *)JSONMap {
    NSDictionary *jsoncode = nil;
    if (!jsoncode) {
        jsoncode = @{

             @"day": @"query.results.channel.item.forecast.day",
             @"high": @"query.results.channel.item.forecast.high",
             @"low": @"query.results.channel.item.forecast.low",
             @"daiycode": @"query.results.channel.item.forecast.code",
             @"sunrise": @"query.results.channel.astronomy.sunrise",
             @"sunset": @"query.results.channel.astronomy.sunset",
             @"city": @"query.results.channel.location.city",
             @"newtemp": @"query.results.channel.item.condition.temp",
             @"newcode": @"query.results.channel.item.condition.code",
             };
    }
    return jsoncode;
}
/*這個我翻得可能不是很標準...
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

@end