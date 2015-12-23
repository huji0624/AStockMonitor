//
//  LHRealTimeStatistics.m
//  AStockMonitor
//
//  Created by __huji on 23/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import "LHRealTimeStatistics.h"
#import <AFHTTPRequestOperationManager.h>

@implementation LHRealTimeStatistics
+(void)poke:(NSString *)action{
    if (!action) {
        return;
    }
    
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:action forKey:@"action"];
    [dict setObject:bid forKey:@"appid"];
    NSString *url = @"http://luckylog.sinaapp.com";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:dict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"poke %@",action);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
@end
