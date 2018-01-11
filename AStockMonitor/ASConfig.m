//
//  ASConfig.m
//  AStockMonitor
//
//  Created by __huji on 8/3/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASConfig.h"
#import <AFHTTPRequestOperationManager.h>
#import <BlocksKit.h>


@implementation ConfigModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

static ConfigModel *_config = nil;
static NSTimer *_timer = nil;

@implementation ASConfig
+(void)startGetConifg{
    NSString *obj = [[NSUserDefaults standardUserDefaults] objectForKey:@"conf"];
    if(obj){
        _config = [[ConfigModel alloc] initWithString:obj error:nil];
    }
    
    [self doGetConfig:nil];
    
    if (!_timer) {
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:60*60*4 block:^(NSTimer *timer) {
            [[self class] startGetConifg];
        } repeats:YES];
    }
}

+(void)doGetConfig:(GetConfigBlock)block{
    NSString *url = [NSString stringWithFormat:@"http://huji0624.github.com/config.html?rand=%@",@(arc4random())];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ConfigModel *conf = [[ConfigModel alloc] initWithDictionary:responseObject error:nil];
        if(conf){
            [[NSUserDefaults standardUserDefaults] setObject:conf.toJSONString forKey:@"conf"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (block) {
            block(conf);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get config fail.%@",error.localizedDescription);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self class] startGetConifg];
        });
    }];
}

+(NSString *)as_chat_url{
    return _config.as_chat_url;
}

+(NSString *)as_host{
    return @"http://123.56.46.78";
}

+(NSString*)as_donations{
    return _config.as_donations;
}

+(NSString *)as_donation_conf{
//    return @"0";
    return _config.as_donation_conf;
}

@end
