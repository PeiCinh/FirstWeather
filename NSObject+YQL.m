//
//  NSObject+YQL.m
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import "NSObject+YQL.h"

#define QUERY_PREFIX @"https://query.yahooapis.com/v1/public/yql?q="
#define QUERY_SQL @"select%20*%20from%20weather.forecast%20where%20woeid%20%3D%20"
#define QUERYWHERE_SQL @"SELECT%20woeid%2Cname%2Ccountry.content%20FROM%20geo.places%20WHERE%20text%3D%22"
#define QUERY_SUFFIX @"%20and%20u%20%3D'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
#define QUERYWHERE_SUFFIX @"%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
@implementation YQL

- (NSDictionary *) query: (NSString *)statement {
    NSString *query = [NSString stringWithFormat:@"%@%@%@%@", QUERY_PREFIX,QUERY_SQL,statement , QUERY_SUFFIX];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    //NSLog(@"results = %@",results);
    return results;
}
- (NSDictionary *) querywhere: (NSString *)statement {
    NSString *query = [NSString stringWithFormat:@"%@%@%@%@", QUERY_PREFIX,QUERYWHERE_SQL,statement , QUERYWHERE_SUFFIX];
    
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    //NSLog(@"results = %@",results);
    return results;
}
@end