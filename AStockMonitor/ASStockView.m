//
//  ASStockView.m
//  AStockMonitor
//
//  Created by __huji on 25/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASStockView.h"
#import <Masonry.h>
#import "ColorButton.h"
#import "MacDevTool.h"

@interface ASStockView ()
@property id stockTag;
@end

@implementation ASStockView{
    NSButton *_button;
    NSStackView *_stack;
    NSButton *_delete;
    NSButton *_down;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _stack = [[NSStackView alloc] init];
        _stack.orientation = NSUserInterfaceLayoutOrientationHorizontal;
        _stack.spacing = 0;
        [MacDevTool setBackground:_stack color:[NSColor whiteColor]];
        
        NSButton *button = [[NSButton alloc] init];
        [button setTitle:@"i"];
        [button  setTarget:self];
        [button setAction:@selector(infoClick:)];
        button.bordered = NO;
        _button = button;
        
        _delete = [[ColorButton alloc] init];
        [_delete setTarget:self];
        [_delete setAction:@selector(deleteClick:)];
        _delete.bordered = NO;
        _delete.hidden = YES;
        [_delete setAttributedTitle:[[NSAttributedString alloc] initWithString:@"删除" attributes:@{NSForegroundColorAttributeName:[NSColor whiteColor]}]];
        
        _down = [[NSButton alloc] init];
        [_down setTarget:self];
        [_down setAction:@selector(downClick:)];
        _down.bordered = NO;
        _down.hidden = YES;
        NSImage *downimg = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down" ofType:@"png"]];
        [_down setImage:downimg];
        
        [self addSubview:button];
        [self addSubview:_stack];
        [self addSubview:_delete];
        [self addSubview:_down];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.mas_height);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_height);
        }];
        [_stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_right);
            make.top.equalTo(self.mas_top);
        }];
        [_delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_stack.mas_right);
//            make.height.equalTo(text.mas_height);
            make.centerY.equalTo(button.mas_centerY);
            make.width.equalTo(_delete.mas_height).multipliedBy(1.1f);
        }];
        [_down mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_delete.mas_left).offset(-2);
            make.height.equalTo(self.mas_height);
            make.centerY.equalTo(button.mas_centerY);
            make.width.equalTo(self.mas_height).multipliedBy(1.2f);
        }];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_left);
            make.right.equalTo(_stack.mas_right);
            make.height.equalTo(_stack.mas_height);
        }];
    }
    return self;
}

-(void)setTag:(id)stockTag info:(NSArray *)info maxs:(NSArray *)maxs{
    NSAssert(info.count==maxs.count, @"info and maxs must have save count.");
    
    self.stockTag = stockTag;
    
    NSArray *subs = [NSArray arrayWithArray:_stack.views];
    for (NSView *view in subs) {
        [view removeFromSuperview];
    }
    
    NSString *fsize = [[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"];
    CGFloat maxhei = 0;
    for (int i =0 ; i<info.count; i++) {
        NSAttributedString *label = info[i];
        NSString *max = maxs[i];
        
        NSFont *thefont = [NSFont systemFontOfSize:fsize.floatValue];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:thefont forKey:NSFontAttributeName];
        NSSize size = [max boundingRectWithSize:NSMakeSize(999, 999) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        CGFloat maxwid = size.width+8;
        if(size.height>maxhei){
            maxhei = size.height;
        }
        
        NSTextField *text = [[NSTextField alloc] init];
        text.editable = NO;
        text.translatesAutoresizingMaskIntoConstraints = NO;
        text.bordered = YES;
        text.bezeled = NO;
        if ([label isMemberOfClass:[NSAttributedString class]]) {
            text.attributedStringValue = label;
        }else{
            text.alignment = NSTextAlignmentLeft;
            text.stringValue = (NSString*)label;
        }
        text.font = thefont;
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(maxwid));
        }];
        
        [_stack addView:text inGravity:NSStackViewGravityLeading];
    }
    
    
    [_stack mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(maxhei));
//        make.width.equalTo(@(wid));
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
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.stockTag];
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
