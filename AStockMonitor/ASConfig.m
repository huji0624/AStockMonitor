//
//  ASConfig.m
//  AStockMonitor
//
//  Created by __huji on 8/3/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASConfig.h"
#import <JSONModel.h>
#import <AFHTTPRequestOperationManager.h>
#import <BlocksKit.h>
#import <EGOCache.h>

@interface ConfigModel : JSONModel
@property (nonatomic,copy) NSString *as_chat_url;
@property (nonatomic,copy) NSString *as_donations;
@property (nonatomic,copy) NSString *as_donation_conf;
@end
@implementation ConfigModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

static ConfigModel *_config = nil;
static NSTimer *_timer = nil;

@implementation ASConfig
+(void)startGetConifg{
    [EGOCache globalCache].defaultTimeoutInterval = 60*60*24*10;
    _config = (ConfigModel*)[[EGOCache globalCache] objectForKey:@"conf"];
    
    [self doGetConfig:nil];
    
    if (!_timer) {
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:60*60*4 block:^(NSTimer *timer) {
            [[self class] startGetConifg];
        } repeats:YES];
    }
}

+(void)doGetConfig:(dispatch_block_t)block{
    NSString *url = [NSString stringWithFormat:@"http://www.whoslab.me/config.html?rand=%@",@(arc4random())];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ConfigModel *conf = [[ConfigModel alloc] initWithDictionary:responseObject error:nil];
        if(conf){
            _config = conf;
            [[EGOCache globalCache] setObject:_config forKey:@"conf"];
        }
        
        if (block) {
            block();
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get config fail.%@",error.localizedDescription);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    return _config.as_donation_conf;
}

@end
