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

@interface AppDelegate ()<ASEditDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong) ASMonitorViewController *monitorVC;
@property (strong) ASEditController *editVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window setLevel:NSFloatingWindowLevel];
    
    self.monitorVC = [[ASMonitorViewController alloc] init];
    self.monitorVC.frame = self.window.contentView.bounds;
    [self.window.contentView addSubview:self.monitorVC.view];
    
    NSString *st = [[NSUserDefaults standardUserDefaults] objectForKey:ASEditTextKey];
    if (!st) {
        st = ASDefaultStocks;
        [[NSUserDefaults standardUserDefaults] setObject:ASDefaultStocks forKey:ASEditTextKey];
    }
    [self setStockString:st];
    
    [self.monitorVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.window.contentView);
    }];
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"调整股票" action:@selector(showEdit) keyEquivalent:@"edit_stock"];
    item.target = self;
    NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"About"];;
    [menu addItem:item];
    [self.window.contentView setMenu:menu];
}

-(void)showEdit{
    if (self.editVC) {
        [self.editVC close];
        self.editVC = nil;
    }
    
    NSUInteger mask = NSTitledWindowMask | NSClosableWindowMask;
    NSWindow *window = [[NSWindow alloc] initWithContentRect:NSRectFromCGRect(CGRectMake(0, 0, 100, 100)) styleMask:mask backing:NSBackingStoreNonretained defer:YES];
    window.title = @"调整股票";
    self.editVC = [[ASEditController alloc] initWithWindow:window];
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
