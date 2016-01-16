//
//  ToolBoxController.m
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ToolBoxController.h"
#import "StocksManager.h"
#import "GetStockRequest.h"

@interface ToolBoxController () <NSTextFieldDelegate>
@property (strong) NSView *contentView;
@property (strong) NSButton *addButton;
@property (strong) NSTextField *codeField;
@end

@implementation ToolBoxController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView = [[NSView alloc] init];
        
        NSButton *button = [[NSButton alloc] init];
        [button setTitle:@"+"];
        [button  setTarget:self];
        [button setAction:@selector(addStock)];
        button.bordered = NO;
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(TOOLBOXHEI));
        }];
        self.addButton = button;
        self.addButton.tag = 0;
        
    }
    return self;
}
-(NSView *)view{
    return self.contentView;
}
-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector{
    if (commandSelector == @selector(insertNewline:)) {
        NSString *code = textView.string;
        if (code.length == 6){
            [self valideStock:code];
        }else{
            [self error:@"股票代码错误"];
        }
        
        return YES;
    }
    return NO;
}

-(void)valideStock:(NSString*)code{
   [self valideAndAddStock:[NSString stringWithFormat:@"sh%@",code] sz:[NSString stringWithFormat:@"sz%@",code]];
}

-(void)valideAndAddStock:(NSString*)sh sz:(NSString*)sz{
    GetStockRequest *req = [[GetStockRequest alloc] init];
    [req requestForStocks:@[sh,sz] block:^(NSArray *stocks) {
        if (stocks) {
            if (stocks.count==1) {
                NSDictionary *info = stocks.lastObject;
                [[StocksManager manager] addStocks:@[info[@"股票代码"]]];
                [self cleanup];
            }else{
                [self error:@"股票代码有误"];
            }
        }else{
            [self error:@"网络错误，请重试"];
        }
    }];
}

-(void)error:(NSString*)err{
    self.codeField.stringValue = err;
}

-(void)addStock{
    if (self.addButton.tag == 0) {
        [self.addButton setTitle:@"x"];
        self.addButton.tag = 1;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(TOOLBOXHEI + TOOLBOXEDITHEI));
        }];
        
        NSTextField *field = [[NSTextField alloc] init];
        field.editable = YES;
        field.placeholderString = @"股票代码+回车";
        field.delegate = self;
        [self.contentView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.addButton.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(TOOLBOXEDITHEI));
        }];
        self.codeField = field;
    }else{
        [self cleanup];
    }
}

-(void)cleanup{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(TOOLBOXHEI));
    }];
    [self.codeField removeFromSuperview];
    self.codeField = nil;
    
    [self.addButton setTitle:@"+"];
    self.addButton.tag = 0;
}

@end
