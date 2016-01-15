//
//  MacDevTool.m
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "MacDevTool.h"

@implementation MacDevTool
+ (void)setBackground:(NSView*)view color:(NSColor*)color
{
    if(![view wantsLayer])
    {
        CALayer* bgLayer = [CALayer layer];
        [bgLayer setBackgroundColor:color.CGColor];
        [view setWantsLayer:TRUE];
        [view setLayer:bgLayer];
    }
    else {
        [view.layer setBackgroundColor:color.CGColor];
    }
}
+ (void)setButtonTitleFor:(NSButton*)button toString:(NSString*)title withColor:(NSColor*)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:title attributes:attrsDictionary];
    [button setAttributedTitle:attrString];
}
@end
