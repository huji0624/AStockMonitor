//
//  ASMonitorViewController.h
//  AStockMonitor
//
//  Created by __huji on 6/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ASMonitorViewControllerDelegate <NSObject>
-(void)didClickInfo:(id)tag;
-(void)didClickChat;
@end

@interface ASMonitorViewController : NSObject

@property (weak) id<ASMonitorViewControllerDelegate> delegate;
@property NSRect frame;

-(void)setUpMainWindow:(NSWindow*)window;

@end
