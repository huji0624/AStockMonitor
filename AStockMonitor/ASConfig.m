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

@interface ConfigModel : JSONModel
@property (nonatomic,copy) NSString *as_chat_url;
@end
@implementation ConfigModel
@end

static ConfigModel *_config = nil;
static NSTimer *_timer = nil;

@implementation ASConfig
+(void)startGetConifg{
    NSString *url = @"http://www.whoslab.me/config.html";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _config = [[ConfigModel alloc] initWithDictionary:responseObject error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get config fail.%@",error.localizedDescription);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[self class] startGetConifg];
        });
    }];
    
    if (!_timer) {
        _timer = [NSTimer bk_scheduledTimerWithTimeInterval:60*60*4 block:^(NSTimer *timer) {
            [[self class] startGetConifg];
        } repeats:YES];
    }
}

+(NSString *)as_chat_url{
    return _config.as_chat_url;
}

+(NSString *)as_host{
    return @"http://123.56.46.78";
}

@end
