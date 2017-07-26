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
#import "LHRealTimeStatistics.h"
#import "ASInfoController.h"
#import "StocksManager.h"
#import "ASMainWindow.h"
#import "ExcuteTimesCache.h"
#import "ASConfig.h"
#import "ASChatMan.h"
//#import "ASChatWindow.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()<ASMonitorViewControllerDelegate>

@property (weak) IBOutlet ASMainWindow *window;
//@property (weak) IBOutlet ASChatWindow *chatWindow;
@property (strong) ASMonitorViewController *monitorVC;
@property (strong) ASInfoController *infoVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"NSApplicationCrashOnExceptions": @YES }];
    [Fabric with:@[[CrashlyticsKit class]]];
    
    [ASConfig startGetConifg];
    
    // Insert code here to initialize your application
    self.window.backgroundColor = [NSColor colorWithWhite:0.95 alpha:1];
    [self.window setLevel:NSFloatingWindowLevel];
    if ([[ASConfig as_donation_conf] isEqualToString:@"0"]) {
        self.window.titleVisibility = NSWindowTitleHidden;
        self.window.titlebarAppearsTransparent = YES;
        self.window.styleMask = NSBorderlessWindowMask;
    }else{
        self.window.titleVisibility = NSWindowTitleVisible;
        self.window.titlebarAppearsTransparent = NO;
        self.window.styleMask = NSWindowStyleMaskMiniaturizable|NSWindowStyleMaskClosable|NSWindowStyleMaskTitled;
        [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
        [[self.window standardWindowButton:NSWindowCloseButton] setHidden:NO];
        [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:NO];
    }
    self.window.movableByWindowBackground = YES;
    
    //chatWindow init
//    [self.chatWindow setLevel:NSFloatingWindowLevel];
//    self.chatWindow.title = @"幽灵感应";
//    [self.chatWindow setIsVisible:NO];
    
    self.monitorVC = [[ASMonitorViewController alloc] init];
    self.monitorVC.delegate = self;
    [self.monitorVC setUpMainWindow:self.window];
    
    NSNumber *alpha = [[NSUserDefaults standardUserDefaults] objectForKey:ASAlphaValueKey];
    if (!alpha) {
        alpha = @(1.0);
        [[NSUserDefaults standardUserDefaults] setObject:alpha forKey:ASAlphaValueKey];
    }
    self.window.alphaValue = alpha.floatValue;
    
    //init
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"fontSize"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"12" forKey:@"fontSize"];
    }
//    [[ASChatMan man] connectChat];
    
    LHS(@"launch");
    
    [self setUpMenu];
}

-(void)setUpMenu{
    
    NSMenuItem *item3 = [[NSMenuItem alloc] initWithTitle:@"打开窗口" action:@selector(showWindow) keyEquivalent:@"edit_format"];
    item3.target = self;
    for (NSMenuItem *temp in [NSApp mainMenu].itemArray) {
        NSMenu *wmenu = temp.submenu;
        if ([wmenu.title isEqualToString:@"Window"]) {
            [wmenu addItem:item3];
        }
    }
}

-(void)showWindow{
    [self.window makeKeyAndOrderFront:nil];
}

-(void)didClickInfo:(id)tag{
    if (!self.infoVC) {
        self.infoVC = [[ASInfoController alloc] initWithWindowNibName:@"ASInfoController"];
    }
    
    self.infoVC.stockCode = tag;
    [self.infoVC showWindow:nil];
}

//-(void)didClickChat{
//    [self.chatWindow setIsVisible:!self.chatWindow.visible];
//}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
