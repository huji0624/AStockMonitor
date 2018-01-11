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
#import "ASConfig.h"

@interface ASMonitorViewController ()<ASStockViewDelegate,ToolBoxDelegate>
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.firstLoad = YES;
        self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:5 block:^(NSTimer *timer) {
            [self requestForStocks];
        } repeats:YES];
        
        self.stockViews = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeFont) name:@"didChangeFont" object:nil];
    }
    return self;
}

-(void)setUpMainWindow:(NSWindow *)window{
    NSView *view = [[NSView alloc] init];
    [MacDevTool setBackground:view color:[NSColor clearColor]];
//    [window.contentView addSubview:view];
    window.contentView = view;
    
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
    self.toolBox.delegate = self;
    self.toolBox.window = window;
    [MacDevTool setBackground:self.toolBox.view color:[NSColor clearColor]];
    [view addSubview:self.toolBox.view];
    [self.toolBox.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(self.stackView.mas_bottom);
        make.height.equalTo(@(hei));
    }];
    
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(window.contentView);
//    }];

    self.window = window;
    
    [self requestForStocks];
}

-(void)requestForStocks{
    NSArray *stockslist = [[StocksManager manager] stocks];
    if (stockslist && stockslist.count>0 && self.request == nil) {
        if (self.firstLoad) {
            [DJProgressHUD showStatus:@"" FromView:self.stackView];
        }
        
        GetStockRequest *req = [[GetStockRequest alloc] init];
        self.request = [req requestForStocks:stockslist block:^(GetStock *stocks) {
            if (stocks) {
                [self updateResponse:stocks];
            }
            
            self.request = nil;
            [DJProgressHUD dismiss];
            self.firstLoad = NO;
        }];
    }
}

-(void)updateResponse:(GetStock*)datas{
    
    NSArray *formats = [self format:datas];
    
    [self refresh:formats];
    
    [self setWindowFrameRight];
}

-(void)setWindowFrameRight{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.stackView.frame.size.width!=0) {
            NSRect frame = self.window.frame;
            if ([[ASConfig as_donation_conf] isEqualToString:@"0"]) {
                frame.size = NSMakeSize(self.stackView.frame.size.width, self.stackView.frame.size.height + self.toolBox.view.frame.size.height);
            }else{
                frame.size = NSMakeSize(self.stackView.frame.size.width, self.stackView.frame.size.height + self.toolBox.view.frame.size.height+23);
            }
            [self.window setFrame:frame display:YES animate:YES];
        }
    });
    
    if (NSApp.keyWindow!=self.window) {
//        [self.window makeKeyAndOrderFront:nil];
    }
}

-(void)didRefresh{
    [self setWindowFrameRight];
    
    [self requestForStocks];
}

-(void)didClickChat{
    //[self.delegate didClickChat];
}

-(NSArray*)format:(GetStock*)datas{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *data in datas.stocks) {
        NSMutableArray *texts = [NSMutableArray arrayWithCapacity:20];
        NSMutableArray *maxs = [NSMutableArray arrayWithCapacity:20];
        
        NSArray *format = [self formats];
        for (NSString *key in format) {
            id v = data[key];
            if (v) {
                [texts addObject:v];
                
                [maxs addObject:datas.max[key]];
            }else{
                NSLog(@"format key %@ value %@ , %@",key,v,data);
            }
        }
        
        //当前涨幅
        NSString *price = data[@"当前价格"];
        NSString *yClose = data[@"昨日收盘价"];
        NSAttributedString *perStr = nil;
        NSMutableParagraphStyle *paragStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragStyle setAlignment:NSTextAlignmentCenter];
        if (price.floatValue == 0) {
            perStr = [[NSAttributedString alloc] initWithString:@"停牌" attributes:@{NSForegroundColorAttributeName:[NSColor grayColor],NSParagraphStyleAttributeName:paragStyle}];
        }else{
            CGFloat percent = (price.floatValue - yClose.floatValue) / yClose.floatValue * 100;
            if (percent>0) {
                perStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",percent] attributes:@{NSForegroundColorAttributeName:[NSColor redColor],NSParagraphStyleAttributeName:paragStyle}];
            }else if (percent<0){
                perStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",percent] attributes:@{NSForegroundColorAttributeName:[NSColor greenColor],NSParagraphStyleAttributeName:paragStyle}];
            }else{
                perStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%",percent] attributes:@{NSForegroundColorAttributeName:[NSColor blackColor],NSParagraphStyleAttributeName:paragStyle}];
            }
        }
        
        [texts addObject:perStr];
        [maxs addObject:@"-10.00%"];
        
        NSMutableDictionary *finalInfo = [NSMutableDictionary dictionary];
        finalInfo[@"texts"] = texts;
        finalInfo[@"key"] = data[@"股票代码"];
        finalInfo[@"maxs"] = maxs;
        
        [array addObject:finalInfo];
    }
    return array;
}

-(NSArray*)formats{
    return [[[ASFormatCache cache] currentFormat] componentsSeparatedByString:ASFormatSep];
}

-(void)refresh:(NSArray*)array{
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.stockViews];
    
    for (NSDictionary *info in array) {
        
        NSArray *texts = info[@"texts"];
        NSString *key = info[@"key"];
        NSArray *maxs = info[@"maxs"];
        
        ASStockView *stock = [tmp firstObject];
        if (stock) {
            [stock setTag:key info:texts maxs:maxs];
            [tmp removeObjectAtIndex:0];
        }else{
            ASStockView *container = [[ASStockView alloc] init];
            container.delegate = self;
            [container setTag:key info:texts maxs:maxs];
            [self.stackView addView:container inGravity:NSStackViewGravityTop];
            [self.stockViews addObject:container];
        }
    }
    
    [self cleanUp:tmp];
}

-(void)didClickInfo:(id)tag{
    NSString *log = [NSString stringWithFormat:@"info_%@",tag];
    LHS(log);
    [self.delegate didClickInfo:tag];
}
-(void)didDeleteStock:(id)tag{
    [[StocksManager manager] removeStock:tag];
    [self requestForStocks];
}
-(void)didDownClick:(id)tag{
    [[StocksManager manager] makeTop:tag];
    [self requestForStocks];
}

-(void)cleanUp:(NSArray*)tmp{
    for (ASStockView *view in tmp) {
        view.delegate = nil;
        [view removeFromSuperview];
        [self.stockViews removeObject:view];
    }
}

-(void)didChangeFont{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.stockViews];
    [self cleanUp:tmp];
    [self requestForStocks];
}
@end
