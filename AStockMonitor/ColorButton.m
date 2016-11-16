//
//  ColorButton.m
//  AStockMonitor
//
//  Created by __huji on 16/11/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ColorButton.h"

@implementation ColorButton

- (void)drawRect:(NSRect)dirtyRect {
    //背景颜色
    [[NSColor colorWithRed:174/255.0 green:69/255.0 blue:55/255.0 alpha:1] set];
    NSRectFill(self.bounds);
    
    [super drawRect:dirtyRect];
}

@end
