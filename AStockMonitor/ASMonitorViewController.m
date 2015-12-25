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
#import "ASFormatCache.h"
#import <DJProgressHUD.h>

@interface ASMonitorViewController ()
@property (strong) NSTimer *timer;
@property (strong) NSStackView *stackView;
@property (strong) AFHTTPRequestOperation *request;
@property BOOL firstLoad;
@end

@implementation ASMonitorViewController

-(void)dealloc{
    self.timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstLoad = YES;
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
        self.stackView.spacing = 0;
    }
    return self.stackView;
}

-(void)requestForStocks{
    if (self.stocks && self.request == nil) {
        if (self.firstLoad) {
            [DJProgressHUD showStatus:@"" FromView:self.stackView];
        }
        
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
            [DJProgressHUD dismiss];
            self.firstLoad = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            self.request = nil;
            [DJProgressHUD dismiss];
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
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
        
        NSArray *format = [self formats];
        for (NSString *key in format) {
            id v = data[key];
            if (v) {
                if ([v isKindOfClass:[NSAttributedString class]]) {
                    [text appendAttributedString:v];
                }else{
                    [text appendAttributedString:[[NSAttributedString alloc] initWithString:v]];
                }
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            }else{
                NSLog(@"format key %@ value %@ , %@",key,v,data);
            }
        }
        
        //当前涨幅
        NSString *price = data[@"当前价格"];
        NSString *yClose = data[@"昨日收盘价"];
        CGFloat percent = (price.floatValue - yClose.floatValue) / yClose.floatValue * 100;
        NSAttributedString *perStr = nil;
        if (percent>0) {
            perStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",percent] attributes:@{NSForegroundColorAttributeName:[NSColor redColor]}];
        }else if (percent<0){
            perStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",percent] attributes:@{NSForegroundColorAttributeName:[NSColor greenColor]}];
        }else{
            perStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",percent] attributes:@{NSForegroundColorAttributeName:[NSColor blackColor]}];
        }
        [text appendAttributedString:perStr];
        
        [array addObject:text];
    }
    return array;
}

-(NSArray*)formats{
    return [[[ASFormatCache cache] currentFormat] componentsSeparatedByString:ASFormatSep];
}

-(NSArray*)parse:(NSString*)text{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        if (line.length>0) {
            NSArray *parts = [line componentsSeparatedByString:@"\""];
            if (parts.count>=2) {
                NSArray *item = [parts[1] componentsSeparatedByString:@","];
                
                NSString *first = parts[0];
                NSString *code = [first substringWithRange:NSMakeRange(first.length-7, 6)];
                
                if (item.count>1) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    NSArray *keys = [[ASFormatCache cache] allKeys];
                    for (NSString *key in keys) {
                        NSNumber *index = [[ASFormatCache cache] objectForKey:key];
                        if (index.intValue>=0 && index.intValue < item.count) {
                            dict[key] = item[index.intValue];
                        }
                    }
                    
                    dict[@"股票代码"] = code;
                    
                    [array addObject:dict];
                }
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
    
    for (NSMutableAttributedString *info in array) {
        NSTextField *text = [[NSTextField alloc] init];
        text.editable = NO;
        text.translatesAutoresizingMaskIntoConstraints = NO;
        text.attributedStringValue = info;
        [text sizeToFit];
        text.tag = 24;
        
        [self.stackView addView:text inGravity:NSStackViewGravityTop];
    }
}

@end
