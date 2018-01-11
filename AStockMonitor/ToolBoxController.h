//
//  ToolBoxController.h
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define TOOLBOXHEI 14
#define TOOLBOXEDITHEI 40
#define TOOLBOXCHATHEI 400

@protocol ToolBoxDelegate <NSObject>
-(void)didRefresh;
-(void)didClickChat;
@end

@interface ToolBoxController : NSObject

@property (weak) id<ToolBoxDelegate> delegate;
@property (weak) NSWindow *window;

-(NSView*)view;

-(void)helpClick;
-(void)openAddStockIfOK;
@end
