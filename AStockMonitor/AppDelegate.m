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
#import "ASFormatController.h"
#import "LHRealTimeStatistics.h"
#import "ASInfoController.h"
#import "StocksManager.h"
#import "ASMainWindow.h"
#import "ExcuteTimesCache.h"
#import "ASConfig.h"
#import "ASChatMan.h"
#import "ASChatWindow.h"

@interface AppDelegate ()<ASMonitorViewControllerDelegate>

@property (weak) IBOutlet ASMainWindow *window;
@property (weak) IBOutlet ASChatWindow *chatWindow;
@property (strong) ASMonitorViewController *monitorVC;
@property (strong) ASFormatController *formatVC;
@property (strong) ASInfoController *infoVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [ASConfig startGetConifg];
    
    // Insert code here to initialize your application
    self.window.backgroundColor = [NSColor colorWithWhite:0.95 alpha:1];
    [self.window setLevel:NSFloatingWindowLevel];
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.movableByWindowBackground = YES;
    self.window.titlebarAppearsTransparent = YES;
    self.window.styleMask = NSBorderlessWindowMask;
    [ExcuteTimesCache excute:@"showHelp" showTimes:1 action:^BOOL(NSUInteger timesIndex) {
        [self.window showHelp:nil];
        return YES;
    }];
    
    //chatWindow init
//    [self.chatWindow setLevel:NSFloatingWindowLevel];
    self.chatWindow.title = @"幽灵感应";
    [self.chatWindow setIsVisible:NO];
    
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
    
    [[ASChatMan man] connectChat];
    
    LHS(@"launch");
}

-(void)didClickInfo:(id)tag{
    if (!self.infoVC) {
        self.infoVC = [[ASInfoController alloc] initWithWindowNibName:@"ASInfoController"];
    }
    
    self.infoVC.stockCode = tag;
    [self.infoVC showWindow:nil];
}

-(void)didClickChat{
    [self.chatWindow setIsVisible:!self.chatWindow.visible];
}

-(void)setUpMenu{
    
    NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"调整格式" action:@selector(showFormat) keyEquivalent:@"edit_format"];
    item3.target = self;
    
    NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"功能"];
    [menu addItem:item3];
    
    NSMenuItem *mainSubItem = [[NSMenuItem alloc] initWithTitle:@"功能" action:nil keyEquivalent:@""];
    mainSubItem.submenu = menu;
    mainSubItem.target = menu;
    
    [[NSApp mainMenu] insertItem:mainSubItem atIndex:[NSApp mainMenu].itemArray.count - 1];
    
//    for (NSMenuItem *temp in [NSApp mainMenu].itemArray) {
//        NSMenu *wmenu = temp.submenu;
//        if ([wmenu.title isEqualToString:@"Window"]) {
//            [wmenu addItem:item3];
//        }
//    }
}

-(void)showFormat{
    LHS(@"showFormat");
    
    if (!self.formatVC) {
        self.formatVC = [[ASFormatController alloc] initWithWindowNibName:@"ASFormatController"];
    }
    
    [self.formatVC showWindow:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
