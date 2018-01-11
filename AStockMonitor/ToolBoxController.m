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
#import "ASChatMan.h"
#import "ASFormatController.h"
#import "ASHelpController.h"
#import "ASQRMoneyController.h"
#import "OpenEnv.h"

@interface ToolBoxController () <NSTextFieldDelegate>
@property (strong) NSView *contentView;
@property (strong) NSTextField *codeField;
@property (strong) NSTextField *marketText;
@property (assign) NSInteger markettag;

@property (strong) NSView *lastAddButton;

@property (strong) NSButton *addButton;
@property (strong) NSButton *chatButton;

@property (strong) ASFormatController *formatVC;
@property (strong) ASHelpController *helpVC;
@property (strong) ASQRMoneyController *qrVC;
@end

@implementation ToolBoxController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView = [[NSView alloc] init];

//        self.chatButton = [self addButton:@"chat" action:@selector(chatClick) size:14];
//        self.chatButton.tag = 0;
        
        [self addButton:@"help" action:@selector(helpClick) size:10];
        [self addButton:@"config" action:@selector(configClick) size:10];
        if ([[ASConfig as_donation_conf] isEqualToString:@"0"]) {
            [self addButton:@"wallet" action:@selector(qrClick) size:10];
        }
        
        self.addButton = [self addButton:@"add" action:@selector(addStock) size:12];
        self.addButton.tag = 0;
        
        [OPEV addEnvID:@"tool" target:self call:^id(id params) {
            return self;
        } des:@"工具"];
        
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
        if (self.markettag == 0 && code.length == 6){
            [self valideAndAddStock:code sz:[NSString stringWithFormat:@"sz%@",code] sh:[NSString stringWithFormat:@"sh%@",code]];
        }else if(self.markettag == 1){
            code = [code lowercaseString];
            NSLog(@"mg code %@",code);
            [self valideAndAddStock:[code copy] sz:[NSString stringWithFormat:@"gb_%@",code] sh:nil];
        }else if(self.markettag == 2){
            [self valideAndAddStock:[code copy] sz:[NSString stringWithFormat:@"rt_hk%@",code] sh:nil];
        }else{
            [self error:[NSString stringWithFormat:@"股票代码错误,%@",code]];
        }
        
        return YES;
    }else if(commandSelector == @selector(insertTab:)){
        if (self.markettag == 0) {
            self.markettag = 1;
        }else if (self.markettag == 1){
            self.markettag = 2;
        }else{
            self.markettag = 0;
        }
        self.marketText.stringValue = [self marketTextWithTag:self.markettag];
        return YES;
    }else if(commandSelector == @selector(cancelOperation:)){
        [self cleanup];
    }
    return NO;
}

-(NSString*)marketTextWithTag:(NSInteger)tag{
    if (tag == 1) {
        return @"美股  Tab切换";
    }else if (tag == 2){
        return @"港股  Tab切换";
    }else{
        return @"A股  Tab切换";
    }
}

-(void)valideAndAddStock:(NSString*)ori sz:(NSString*)sz sh:(NSString*)sh{
    self.addButton.enabled = NO;
    self.codeField.editable = NO;
    [self.window makeFirstResponder:nil];
    
    GetStockRequest *req = [[GetStockRequest alloc] init];
    NSMutableArray *reqs = [NSMutableArray array];
    if(sz) [reqs addObject:sz];
    if(sh) [reqs addObject:sh];
    [req requestForStocks:reqs block:^(GetStock *stocks) {
        if (stocks) {
            if (stocks.stocks.count>0) {
                for (NSDictionary *info in stocks.stocks) {
                     [[StocksManager manager] addStocks:@[info[@"股票代码"]]];
                }
                [self cleanup];
            }else{
                NSLog(@"股票代码有误 %@",ori);
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
        
        NSTextField *market = [[NSTextField alloc] init];
        market.editable = NO;
        market.translatesAutoresizingMaskIntoConstraints = NO;
        market.bordered = YES;
        market.bezeled = NO;
        market.alignment = NSTextAlignmentCenter;
        market.stringValue = [self marketTextWithTag:self.markettag];
        self.marketText = market;
        [self.contentView addSubview:self.marketText];
        [self.marketText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.addButton.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(TOOLBOXEDITHEI/2));
        }];
        
        NSTextField *field = [[NSTextField alloc] init];
        field.editable = YES;
        field.selectable = YES;
        field.placeholderString = @"股票代码+回车";
        field.delegate = self;
        [self.contentView addSubview:field];
        [field mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.top.equalTo(self.marketText.mas_bottom);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@(TOOLBOXEDITHEI/2));
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
    
    [self.marketText removeFromSuperview];
    self.marketText = nil;
    
    [self.codeField removeFromSuperview];
    self.codeField = nil;
    NSImage *addimg = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add" ofType:@"png"]];
    [self.addButton setImage:addimg];
    self.addButton.tag = 0;
    
    self.chatButton.tag = 0;
    
    [self.delegate didRefresh];
}

-(void)chatClick{
    LHS(@"chat");
    NSUserDefaults *df =[NSUserDefaults standardUserDefaults];
    NSString *cid = [df objectForKey:@"chat_id"];
    if (cid) {
        //打开面板
        [self openChat];
    }else{
        //cid不存在.自动在server生成一个.
        NSString *url = [NSString stringWithFormat:@"%@/newchatuser",[ASConfig as_host]];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = responseObject;
            NSNumber *res = dict[@"res"];
            if (res.integerValue == 0) {
                NSString *chat_id = dict[@"chat_id"];
                NSString *image_url = dict[@"image_url"];
                
                [df setObject:chat_id forKey:@"chat_id"];
                [df setObject:image_url forKey:@"image_url"];
                [df synchronize];
                
                NSLog(@"synchronize %@ %@",chat_id,image_url);
                
                [[ASChatMan man] connectChat];
                
            }else{
                NSAlert *alert = [[NSAlert alloc] init];
                alert.messageText = [NSString stringWithFormat:@"服务器错误 %@",res];
                [alert runModal];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"newchatuser %@",[error localizedDescription]);
        }];
    }
}

-(void)openChat{
    
}

-(void)configClick{
    LHS(@"showFormat");
    
    if (!self.formatVC) {
        self.formatVC = [[ASFormatController alloc] initWithWindowNibName:@"ASFormatController"];
    }
    
    [self.formatVC showWindow:nil];
}

-(void)helpClick{
    if (!self.helpVC) {
        self.helpVC = [[ASHelpController alloc] initWithWindowNibName:@"ASHelpController"];
    }
    [self.helpVC showWindow:nil];
}

-(void)qrClick{
    if (!self.qrVC) {
        self.qrVC = [[ASQRMoneyController alloc] initWithWindowNibName:@"ASQRMoneyController"];
    }
    [self.qrVC showWindow:nil];
}

@end
