//
//  ASChatView.h
//  AStockMonitor
//
//  Created by __huji on 25/5/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ASChatView : NSView

-(void)addMessage:(NSString*)from msg:(NSString*)msg;

@end
