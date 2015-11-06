//
//  AppDelegate.m
//  AStockMonitor
//
//  Created by __huji on 6/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "AppDelegate.h"
#import "ASMonitorViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) ASMonitorViewController *monitorVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self.window setLevel:NSFloatingWindowLevel];
    
    self.monitorVC = [[ASMonitorViewController alloc] init];
    self.monitorVC.frame = self.window.contentView.bounds;
    [self.window.contentView addSubview:self.monitorVC.view];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
