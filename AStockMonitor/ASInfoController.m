//
//  ASInfoController.m
//  AStockMonitor
//
//  Created by __huji on 25/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASInfoController.h"
#import <DJProgressHUD.h>

@interface ASInfoController ()

@end

@implementation ASInfoController{
    NSImageView *_kImageView;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    CGFloat bw = 50;
    
    int count = 4;
    CGFloat hei = self.window.contentView.frame.size.height/4;
    for (int i=0; i<count; i++) {
        NSButton *bt = [[NSButton alloc] init];
        bt.tag = i;
        if (i==0) {
            bt.title = @"月K";
        }else if (i==1){
            bt.title = @"周K";
        }else if (i==2){
            bt.title = @"日K";
        }else if (i==3){
            bt.title = @"分时";
        }
        bt.frame = CGRectMake(0, i*hei, bw, hei);
        bt.target = self;
        bt.action = @selector(clickButton:);
        [self.window.contentView addSubview:bt];
    }
    
    NSImageView *img = [[NSImageView alloc] initWithFrame:CGRectMake(bw, 0, self.window.frame.size.width - bw, self.window.frame.size.height)];
    [self.window.contentView addSubview:img];
    _kImageView = img;
}

-(void)clickButton:(NSButton*)sender{
    [self loadKImageFor:sender.tag];
}

-(void)showWindow:(id)sender{
    [super showWindow:sender];
    
    [self loadKImageFor:3];
}

-(void)loadKImageFor:(NSInteger)index{
    
    NSMutableString *url = [NSMutableString stringWithString:@"http://image.sinajs.cn/newchart/"];
    if (index==0) {
        [url appendString:@"monthly/"];
    }else if (index==1){
        [url appendString:@"weekly/"];
    }else if (index==2){
        [url appendString:@"daily/"];
    }else if (index==3){
        [url appendString:@"min/"];
    }
    [url appendString:@"n/"];
    [url appendString:self.stockCode];
    [url appendString:@".gif"];
    
    [DJProgressHUD showStatus:@"加载中..." FromView:self.window.contentView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_kImageView setImage:image];
            [DJProgressHUD dismiss];
        });
    });
    
}

@end
