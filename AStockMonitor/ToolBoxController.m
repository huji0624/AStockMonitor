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
#import "ASConfig.h"
#import "ASChatView.h"

@interface ToolBoxController () <NSTextFieldDelegate>
@property (strong) NSView *contentView;
@property (strong) NSTextField *codeField;
@property (strong) ASChatView *chatView;

@property (strong) NSView *lastAddButton;

@property (strong) NSButton *addButton;
@property (strong) NSButton *chatButton;
@end

@implementation ToolBoxController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView = [[NSView alloc] init];

        self.chatButton = [self addButton:@"chat" action:@selector(chatClick) size:14];
        self.chatButton.tag = 0;
        
        self.addButton = [self addButton:@"add" action:@selector(addStock) size:12];
        self.addButton.tag = 0;
        
    }
    return self;
}

-(NSButton*)addButton:(NSString*)imageName action:(SEL)action size:(CGFloat)size{
    NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    img.size = NSMakeSize(size, size);
    NSButton *button = [[NSButton alloc] init];
    [button setImage:img];
    [button  setTarget:self];
    [button setAction:action];
    button.bordered = NO;
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lastAddButton?self.lastAddButton.mas_right:self.contentView.mas_left).offset(2);
        make.top.equalTo(self.contentView);
        if ([imageName isEqualToString:@"add"]) {
            make.width.equalTo(self.contentView.mas_width).offset(-14);
        }else{
            make.width.equalTo(@(img.size.width));
        }
        make.height.equalTo(@(TOOLBOXHEI));
    }];
    
    
    self.lastAddButton = button;
    return button;
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
            [self error:[NSString stringWithFormat:@"股票代码错误,%@",code]];
        }
        
        return YES;
    }
    return NO;
}

-(void)valideStock:(NSString*)code{
   [self valideAndAddStock:code sz:[NSString stringWithFormat:@"sz%@",code] sh:[NSString stringWithFormat:@"sh%@",code]];
}

-(void)valideAndAddStock:(NSString*)ori sz:(NSString*)sz sh:(NSString*)sh{
    self.addButton.enabled = NO;
    self.codeField.editable = NO;
    [self.window makeFirstResponder:nil];
    
    GetStockRequest *req = [[GetStockRequest alloc] init];
    [req requestForStocks:@[sh,sz] block:^(NSArray *stocks) {
        if (stocks) {
            if (stocks.count>0) {
                for (NSDictionary *info in stocks) {
                     [[StocksManager manager] addStocks:@[info[@"股票代码"]]];
                }
                [self cleanup];
            }else{
                [self error:[NSString stringWithFormat:@"股票代码有误,%@",ori]];
            }
        }else{
            [self error:@"网络错误，请重试"];
        }
        
        self.addButton.enabled = YES;
        self.codeField.editable = YES;
    }];
}

-(void)error:(NSString*)err{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = err;
    [alert addButtonWithTitle:@"确定"];
    [alert runModal];
    
    LHS(err);
}

-(void)addStock{
    if (self.addButton.tag == 0) {
        LHS(@"showaddstock");
        
        NSImage *closeimg = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"close" ofType:@"png"]];
        [self.addButton setImage:closeimg];
        self.addButton.tag = 1;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(TOOLBOXHEI + TOOLBOXEDITHEI));
        }];
        
        NSTextField *field = [[NSTextField alloc] init];
        field.editable = YES;
        field.selectable = YES;
        field.placeholderString = @"股票代码+回车";
        field.delegate = self;
        [self.contentView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.addButton.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(TOOLBOXEDITHEI));
        }];
        [self.window makeFirstResponder:field];
        self.codeField = field;
        
        [self.delegate didRefresh];
    }else{
        LHS(@"closeadd");
        
        [self cleanup];
    }
}

-(void)cleanup{
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(TOOLBOXHEI));
    }];
    
    [self.codeField removeFromSuperview];
    self.codeField = nil;
    NSImage *addimg = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add" ofType:@"png"]];
    [self.addButton setImage:addimg];
    self.addButton.tag = 0;
    
    [self.chatView removeFromSuperview];
    self.chatView = nil;
    self.chatButton.tag = 0;
    
    [self.delegate didRefresh];
}

-(void)chatClick{
    LHS(@"chat");
    
    if (self.chatButton.tag==0) {
        
        self.chatButton.tag = 1;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(TOOLBOXHEI + TOOLBOXCHATHEI));
        }];
        
        if (self.chatView == nil) {
            ASChatView *cv = [[ASChatView alloc] init];
            [self.contentView addSubview:cv];
            [cv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left);
                make.top.equalTo(self.chatButton.mas_bottom);
                make.right.equalTo(self.contentView.mas_right);
                make.height.equalTo(@(TOOLBOXCHATHEI));
            }];
            self.chatView = cv;
        }else{
            [self.contentView addSubview:self.chatView];
        }
        
        [self.window makeFirstResponder:self.chatView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatView addMessage:@"from" msg:@"assd"];
            [self.chatView addMessage:@"from" msg:@"ass1222d"];
            [self.chatView addMessage:@"from" msg:@"ooqw"];
        });
        
        
        [self.delegate didRefresh];
        
    }else{
        [self cleanup];
    }
}

@end
