//
//  AppDelegate.m
//  AStockMonitor
//
//  Created by __huji on 6/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "AppDelegate.h"
#import "ASMonitorViewController.h"
#import <Masonry.h>
#import "ASEditController.h"
#import "ASConstant.h"
#import <AFHTTPRequestOperationManager.h>
#import "ASAppearanceController.h"

@interface AppDelegate ()<ASEditDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong) ASMonitorViewController *monitorVC;
@property (strong) ASEditController *editVC;
@property (strong) ASAppearanceController *appearanceVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window setLevel:NSFloatingWindowLevel];
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.movableByWindowBackground = YES;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask = NSBorderlessWindowMask|NSResizableWindowMask;
    
    self.monitorVC = [[ASMonitorViewController alloc] init];
    self.monitorVC.frame = self.window.contentView.bounds;
    [self.window.contentView addSubview:self.monitorVC.view];
    
    NSNumber *alpha = [[NSUserDefaults standardUserDefaults] objectForKey:ASAlphaValueKey];
    if (!alpha) {
        alpha = @(1.0);
        [[NSUserDefaults standardUserDefaults] setObject:alpha forKey:ASAlphaValueKey];
    }
    self.window.alphaValue = alpha.floatValue;
    
    NSString *st = [[NSUserDefaults standardUserDefaults] objectForKey:ASEditTextKey];
    if (!st) {
        st = ASDefaultStocks;
        [[NSUserDefaults standardUserDefaults] setObject:ASDefaultStocks forKey:ASEditTextKey];
    }
    [self setStockString:st];
    
    [self.monitorVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.window.contentView);
    }];
    
    [self setUpMenu];
}

-(void)setUpMenu{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"调整股票" action:@selector(showEdit) keyEquivalent:@"edit_stock"];
    item.target = self;
    
    NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"调整样式" action:@selector(showAppearance) keyEquivalent:@"edit_appearance"];
    item2.target = self;
    
    NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"功能"];
    [menu addItem:item];
    [menu addItem:item2];
    
    NSMenuItem *mainSubItem = [[NSMenuItem alloc] initWithTitle:@"ss" action:nil keyEquivalent:@""];
    mainSubItem.submenu = menu;
    mainSubItem.target = menu;
    
    [[NSApp mainMenu] insertItem:mainSubItem atIndex:1];
}

-(void)showAppearance{
    if (self.appearanceVC) {
        [self.appearanceVC close];
        self.appearanceVC = nil;
    }
    
    self.appearanceVC = [[ASAppearanceController alloc] initWithWindowNibName:@"ASAppearanceController"];
    [self.appearanceVC showWindow:nil];
    
    self.appearanceVC.alphaTargetView = self.window;
}

-(void)showEdit{
    if (self.editVC) {
        [self.editVC close];
        self.editVC = nil;
    }
    
    NSUInteger mask = NSTitledWindowMask | NSClosableWindowMask;
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSRectFromCGRect(CGRectMake(0, 0, 300, 300)) styleMask:mask backing:NSBackingStoreBuffered defer:YES];
    window.title = @"调整股票";
    self.editVC = [[ASEditController alloc] initWithWindow:window];
    self.editVC.delegate = self;
    [self.editVC showWindow:nil];
}

-(void)setStockString:(NSString*)string{
    self.monitorVC.stocks = [string componentsSeparatedByString:@","];
}

-(void)didSaveMonitorStock:(NSString *)string{
    [self setStockString:string];
    
    [self.editVC close];
    self.editVC = nil;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
