//
//  ASMonitorViewController.m
//  AStockMonitor
//
//  Created by __huji on 6/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASMonitorViewController.h"
#import <AFHTTPRequestOperationManager.h>
#import <BlocksKit.h>

@interface ASMonitorViewController ()
@property (strong) NSTimer *timer;
@property (strong) NSStackView *stackView;
@property (strong) AFHTTPRequestOperation *request;
@end

@implementation ASMonitorViewController

-(void)dealloc{
    self.timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:2 block:^(NSTimer *timer) {
            [self requestForStocks];
        } repeats:YES];
        
    }
    return self;
}

-(NSView *)view{
    if (self.stackView == nil) {
        self.stackView = [[NSStackView alloc] initWithFrame:self.frame];
        self.stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    }
    return self.stackView;
}

-(void)requestForStocks{
    if (self.stocks && self.request == nil) {
        NSMutableString *url = [NSMutableString stringWithString:@"http://hq.sinajs.cn/list="];
        NSString *stockString = [self.stocks componentsJoinedByString:@","];
        [url appendString:stockString];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.request = [manager GET:url parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *data = responseObject;
            
            NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:enc];
            [self updateResponse:responseString];

            self.request = nil;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            self.request = nil;
        }];
    }
}

-(void)updateResponse:(NSString*)text{
    NSArray *datas = [self parse:text];
    
    NSArray *formats = [self format:datas];
    
    [self refresh:formats];
}

-(NSArray*)format:(NSArray*)datas{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *data in datas) {
        NSString *price = data[@"price"];
        NSString *yClose = data[@"yclose"];
        
        CGFloat percent = (price.floatValue - yClose.floatValue) / yClose.floatValue * 100;
        
        NSString *text = [NSString stringWithFormat:@"%@ %.2f%%",data[@"name"],percent];
        [array addObject:text];
    }
    return array;
}

-(NSArray*)parse:(NSString*)text{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        if (line.length>0) {
            NSArray *parts = [line componentsSeparatedByString:@"\""];
            NSArray *item = [parts[1] componentsSeparatedByString:@","];
            
            if (item.count>1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"name"] = item[0];
                dict[@"open"] = item[1];
                dict[@"yclose"] = item[2];
                dict[@"price"] = item[3];
                dict[@"top"] = item[4];
                dict[@"bottom"] = item[5];
                
                [array addObject:dict];
            }
            
        }
    }
    
    return array;
}

-(void)refresh:(NSArray*)array{
    NSArray *subViews = [NSArray arrayWithArray:self.stackView.views];
    for (NSView *view in subViews) {
        if (view.tag == 24) {
            [self.stackView removeView:view];
        }
    }
    
    for (NSString *info in array) {
        NSTextField *text = [[NSTextField alloc] init];
        text.editable = NO;
        text.translatesAutoresizingMaskIntoConstraints = NO;
        text.stringValue = info;
        [text sizeToFit];
        text.tag = 24;
        
        [self.stackView addView:text inGravity:NSStackViewGravityTop];
    }
}

@end
