//
//  NSObject+YQL.h
//  TaichungWeather
//
//  Created by Huang YangChing on 2016/1/7.
//  Copyright © 2016年 Huang YangChing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YQL : NSObject

- (NSDictionary *)query:(NSString *)statement;
- (NSDictionary *) querywhere: (NSString *)statement;
@end