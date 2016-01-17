//
//  ToolBoxController.h
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define TOOLBOXHEI 12
#define TOOLBOXEDITHEI 20

@protocol ToolBoxDelegate <NSObject>
-(void)didRefresh;
@end

@interface ToolBoxController : NSObject

@property (weak) id<ToolBoxDelegate> delegate;
@property (weak) NSWindow *window;

-(NSView*)view;
@end
