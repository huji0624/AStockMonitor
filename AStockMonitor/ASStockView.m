//
//  ASStockView.m
//  AStockMonitor
//
//  Created by __huji on 25/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASStockView.h"
#import <Masonry.h>
#import "RSVerticallyCenteredTextFieldCell.h"

@implementation ASStockView{
    NSButton *_button;
    NSTextField *_text;
}

-(instancetype)initWithInfo:(NSAttributedString *)info{
    self = [super init];
    if (self) {
        
        CGFloat hei = 18;
        NSTextField *text = [[NSTextField alloc] init];
        text.editable = NO;
        text.translatesAutoresizingMaskIntoConstraints = NO;
        text.attributedStringValue = info;
        text.alignment = NSTextAlignmentCenter;
        text.bordered = NO;
        [text setCell:[[RSVerticallyCenteredTextFieldCell alloc] initTextCell:(NSString*)info]];
        _text = text;
        
        NSButton *button = [[NSButton alloc] init];
        [button setTitle:@"i"];
        [button  setTarget:self];
        [button setAction:@selector(infoClick:)];
        button.bordered = NO;
        _button = button;

        [self addSubview:button];
        [self addSubview:text];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_height);
        }];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(button.mas_right);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(text.mas_width).offset(hei);
            make.height.equalTo(@(hei));
        }];
    }
    return self;
}

-(void)infoClick:(id)sender{
    [self.delegate didClickInfo:self.stockTag];
}

-(NSInteger)tag{
    return 24;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
