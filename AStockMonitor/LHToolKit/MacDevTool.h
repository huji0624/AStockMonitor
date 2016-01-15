//
//  MacDevTool.h
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MacDevTool : NSObject
+ (void)setBackground:(NSView*)view color:(NSColor*)color;
+ (void)setButtonTitleFor:(NSButton*)button toString:(NSString*)title withColor:(NSColor*)color;
@end
