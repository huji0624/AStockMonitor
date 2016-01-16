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
#import "ASConstant.h"
#import <AFHTTPRequestOperationManager.h>
#import "ASAppearanceController.h"
#import "ASFormatController.h"
#import "LHRealTimeStatistics.h"
#import "ASInfoController.h"
#import "StocksManager.h"

@interface AppDelegate ()<ASMonitorViewControllerDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong) ASMonitorViewController *monitorVC;
@property (strong) ASAppearanceController *appearanceVC;
@property (strong) ASFormatController *formatVC;
@property (strong) ASInfoController *infoVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window setLevel:NSFloatingWindowLevel];
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.movableByWindowBackground = YES;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask = NSBorderlessWindowMask;
    
    self.monitorVC = [[ASMonitorViewController alloc] init];
    self.monitorVC.delegate = self;
    [self.monitorVC setUpMainWindow:self.window];
    
    NSNumber *alpha = [[NSUserDefaults standardUserDefaults] objectForKey:ASAlphaValueKey];
    if (!alpha) {
        alpha = @(1.0);
        [[NSUserDefaults standardUserDefaults] setObject:alpha forKey:ASAlphaValueKey];
    }
    self.window.alphaValue = alpha.floatValue;
    
    [self setUpMenu];
    
    LHS(@"launch");
}

-(void)didClickInfo:(id)tag{
    if (!self.infoVC) {
        self.infoVC = [[ASInfoController alloc] initWithWindowNibName:@"ASInfoController"];
    }
    
    self.infoVC.stockCode = tag;
    [self.infoVC showWindow:nil];
}

-(void)setUpMenu{
    
    NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"调整样式" action:@selector(showAppearance) keyEquivalent:@"edit_appearance"];
    item2.target = self;
    
    NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"调整格式" action:@selector(showFormat) keyEquivalent:@"edit_format"];
    item3.target = self;
    
    NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"功能"];
    [menu addItem:item2];
    [menu addItem:item3];
    
    NSMenuItem *mainSubItem = [[NSMenuItem alloc] initWithTitle:@"功能" action:nil keyEquivalent:@""];
    mainSubItem.submenu = menu;
    mainSubItem.target = menu;
    
    [[NSApp mainMenu] insertItem:mainSubItem atIndex:[NSApp mainMenu].itemArray.count - 1];
    
    
}

-(void)setUpWindowMenu{
    
    NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"调整样式" action:@selector(showAppearance) keyEquivalent:@"edit_appearance"];
    item2.target = self;
    
    NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"调整格式" action:@selector(showFormat) keyEquivalent:@"edit_format"];
    item3.target = self;
    for (NSMenuItem *temp in [NSApp mainMenu].itemArray) {
        NSMenu *wmenu = temp.submenu;
        if ([wmenu.title isEqualToString:@"Window"]) {
            [wmenu addItem:item2];
            [wmenu addItem:item3];
        }
    }
}

-(void)showFormat{
    LHS(@"showFormat");
    
    if (!self.formatVC) {
        self.formatVC = [[ASFormatController alloc] initWithWindowNibName:@"ASFormatController"];
    }
    
    [self.formatVC showWindow:nil];
}

-(void)showAppearance{
    if (!self.appearanceVC) {
        self.appearanceVC = [[ASAppearanceController alloc] initWithWindowNibName:@"ASAppearanceController"];
        self.appearanceVC.alphaTargetView = self.window;
    }
    
    [self.appearanceVC showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
