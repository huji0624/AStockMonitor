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
    NSButton *_down;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
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
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"delete" ofType:@"png"]];
        [_delete setImage:img];
        
        _down = [[NSButton alloc] init];
        [_down setTarget:self];
        [_down setAction:@selector(downClick:)];
        _down.bordered = NO;
        _down.hidden = YES;
        NSImage *downimg = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]];
        [_down setImage:downimg];
        
        [self addSubview:button];
        [self addSubview:text];
        [self addSubview:_delete];
        [self addSubview:_down];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_height);
        }];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_right);
        }];
        [_delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(text.mas_right);
            make.height.equalTo(text.mas_height);
            make.centerY.equalTo(button.mas_centerY);
            make.width.equalTo(text.mas_height).multipliedBy(1.5f);
        }];
        [_down mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_delete.mas_left).offset(-2);
            make.height.equalTo(self.mas_height);
            make.width.equalTo(self.mas_height).multipliedBy(1.2f);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_left);
            make.right.equalTo(text.mas_right);
            make.height.equalTo(text.mas_height);
        }];
    }
    return self;
}

-(void)setTag:(id)stockTag info:(NSAttributedString *)info{
    self.stockTag = stockTag;
    
    NSString *fsize = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"];
    
    _text.attributedStringValue = info;
    RSVerticallyCenteredTextFieldCell *cell = [[RSVerticallyCenteredTextFieldCell alloc] initTextCell:(NSString*)info];
    cell.font = [NSFont systemFontOfSize:fsize.floatValue];;
    [_text setCell:cell];
    [_text mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(fsize.floatValue*1.1));
    }];
    
    _button.font = [NSFont systemFontOfSize:fsize.floatValue];;
    
    if (self.trackingAreas.count == 0 && self.frame.size.width != 0 ) {
        NSTrackingArea *track = [[NSTrackingArea alloc] initWithRect:self.bounds options: (NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways) owner:self userInfo:nil];
        [self addTrackingArea:track];
    }
}

-(void)mouseEntered:(NSEvent *)theEvent{
    _delete.hidden = NO;
    _down.hidden = NO;
}

-(void)mouseExited:(NSEvent *)theEvent{
    _delete.hidden = YES;
    _down.hidden = YES;
}

-(void)infoClick:(id)sender{
    [self.delegate didClickInfo:self.stockTag];
}

-(void)deleteClick:(id)sender{
    LHS(@"stockdelete");
    
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

-(void)downClick:(id)sender{
    LHS(@"stockdown");
    
    [self.delegate didDownClick:self.stockTag];
}

-(void)confirmDelete{
    [self.delegate didDeleteStock:self.stockTag];
    [NSApp stopModal];
}

-(NSInteger)tag{
    return 24;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
