//
//  ASHelpController.m
//  AStockMonitor
//
//  Created by __huji on 28/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASHelpController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface ASHelpController ()
@property (strong) WebView *webView;
@end

@implementation ASHelpController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.webView = [[WebView alloc] initWithFrame:self.window.contentView.bounds];
    [self.window.contentView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window.contentView);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"幽灵股票-帮助" ofType:@"html"]]];
    [[self.webView mainFrame] loadRequest:request];
}

@end
