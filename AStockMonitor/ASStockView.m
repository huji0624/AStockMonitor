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

@interface ASStockView ()
@property id stockTag;
@end

@implementation ASStockView{
    NSButton *_button;
    NSTextField *_text;
    NSButton *_delete;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints = YES;
        
        CGFloat hei = 18;
        NSTextField *text = [[NSTextField alloc] init];
        text.editable = NO;
        text.translatesAutoresizingMaskIntoConstraints = NO;
        text.alignment = NSTextAlignmentCenter;
        text.bordered = NO;
        _text = text;
        
        NSButton *button = [[NSButton alloc] init];
        [button setTitle:@"i"];
        [button  setTarget:self];
        [button setAction:@selector(infoClick:)];
        button.bordered = NO;
        _button = button;
        
        _delete = [[NSButton alloc] init];
        [_delete setTarget:self];
        [_delete setAction:@selector(deleteClick:)];
        _delete.bordered = NO;
        _delete.hidden = YES;
        [MacDevTool setBackground:_delete color:[NSColor redColor]];
        [MacDevTool setButtonTitleFor:_delete toString:@"删除" withColor:[NSColor whiteColor]];

        [self addSubview:button];
        [self addSubview:text];
        [self addSubview:_delete];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_height);
        }];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(button.mas_right);
        }];
        [_delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(text.mas_width).offset(hei);
            make.height.equalTo(@(hei));
        }];
    }
    return self;
}

-(void)setTag:(id)stockTag info:(NSAttributedString *)info{
    self.stockTag = stockTag;
    
    _text.attributedStringValue = info;
    [_text setCell:[[RSVerticallyCenteredTextFieldCell alloc] initTextCell:(NSString*)info]];
    
    if (self.trackingAreas.count == 0 && self.frame.size.width != 0 ) {
        NSTrackingArea *track = [[NSTrackingArea alloc] initWithRect:self.bounds options: (NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways) owner:self userInfo:nil];
        [self addTrackingArea:track];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent{
    _delete.hidden = NO;
}

-(void)mouseExited:(NSEvent *)theEvent{
    _delete.hidden = YES;
}

-(void)infoClick:(id)sender{
    [self.delegate didClickInfo:self.stockTag];
}

-(void)deleteClick:(id)sender{
    NSAttributedString *string = _text.attributedStringValue;
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = [NSString stringWithFormat:@"确定要删除 %@ 吗?",string.string];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    NSButton *bt = [alert.buttons firstObject];
    bt.target = self;
    bt.action = @selector(confirmDelete);
    [alert runModal];
}

-(void)confirmDelete{
    
}

-(NSInteger)tag{
    return 24;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
