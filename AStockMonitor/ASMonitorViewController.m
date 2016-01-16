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
#import "ASStockView.h"
#import "LHRealTimeStatistics.h"
#import "StocksManager.h"
#import "ToolBoxController.h"
#import "GetStockRequest.h"

@interface ASMonitorViewController ()<ASStockViewDelegate>
@property (strong) NSTimer *timer;
@property (strong) NSStackView *stackView;
@property (strong) AFHTTPRequestOperation *request;
@property BOOL firstLoad;
@property (strong) NSMutableArray *stockViews;
@property (strong) ToolBoxController *toolBox;
@property (strong) NSWindow *window;
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
        
        self.stockViews = [NSMutableArray array];
    }
    return self;
}

-(void)setUpMainWindow:(NSWindow *)window{
    NSView *view = [[NSView alloc] init];
    [MacDevTool setBackground:view color:[NSColor whiteColor]];
    [window.contentView addSubview:view];
    
    CGFloat hei = TOOLBOXHEI;
    
    self.stackView = [[NSStackView alloc] init];
    self.stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    self.stackView.spacing = 0;
    self.stackView.alignment = NSLayoutAttributeLeft;
    [MacDevTool setBackground:self.stackView color:[NSColor whiteColor]];
    [view addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.top.equalTo(view.mas_top);
    }];
    
    self.toolBox = [[ToolBoxController alloc] init];
    [MacDevTool setBackground:self.toolBox.view color:[NSColor lightGrayColor]];
    [view addSubview:self.toolBox.view];
    [self.toolBox.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(self.stackView.mas_bottom);
        make.height.equalTo(@(hei));
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window.contentView);
    }];

    self.window = window;
}

-(void)requestForStocks{
    NSArray *stockslist = [[StocksManager manager] stocks];
    if (stockslist && self.request == nil) {
        if (self.firstLoad) {
            [DJProgressHUD showStatus:@"" FromView:self.stackView];
        }
        
        GetStockRequest *req = [[GetStockRequest alloc] init];
        self.request = [req requestForStocks:stockslist block:^(NSArray *stocks) {
            if (stocks) {
                [self updateResponse:stocks];
            }
            
            self.request = nil;
            [DJProgressHUD dismiss];
            self.firstLoad = NO;
        }];
    }
}

-(void)updateResponse:(NSArray*)datas{
    
    NSArray *formats = [self format:datas];
    
    [self refresh:formats];
    
    NSRect frame = self.window.frame;
    frame.size = NSMakeSize(self.stackView.frame.size.width, self.stackView.frame.size.height + self.toolBox.view.frame.size.height);
    [self.window setFrame:frame display:YES animate:YES];
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
        
        NSMutableDictionary *finalInfo = [NSMutableDictionary dictionary];
        finalInfo[@"text"] = text;
        finalInfo[@"key"] = data[@"股票代码"];
        
        [array addObject:finalInfo];
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
                NSString *code = [first substringWithRange:NSMakeRange(first.length-9, 8)];
                
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
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.stockViews];
    
    for (NSDictionary *info in array) {
        
        NSAttributedString *text = info[@"text"];
        NSString *key = info[@"key"];
        
        ASStockView *stock = [tmp firstObject];
        if (stock) {
            [stock setTag:key info:text];
            [tmp removeObjectAtIndex:0];
        }else{
            ASStockView *container = [[ASStockView alloc] init];
            container.delegate = self;
            [container setTag:key info:text];
            [self.stackView addView:container inGravity:NSStackViewGravityTop];
            [self.stockViews addObject:container];
        }
    }
    
    for (ASStockView *view in tmp) {
        view.delegate = nil;
        [view removeFromSuperview];
        [self.stockViews removeObject:view];
    }
}

-(void)didClickInfo:(id)tag{
    NSString *log = [NSString stringWithFormat:@"info_%@",tag];
    LHS(log);
    [self.delegate didClickInfo:tag];
}
-(void)didDeleteStock:(id)tag{
    [[StocksManager manager] removeStock:tag];
}
@end
