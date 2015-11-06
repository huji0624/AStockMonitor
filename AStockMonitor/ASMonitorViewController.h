//
//  ASMonitorViewController.h
//  AStockMonitor
//
//  Created by __huji on 6/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ASMonitorViewController : NSObject

@property NSRect frame;
@property (strong) NSArray *stocks;//code like sz000213

-(NSView*)view;

@end
