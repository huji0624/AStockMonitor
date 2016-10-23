//
//  ASChatWindow.h
//  AStockMonitor
//
//  Created by __huji on 23/10/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ASChatWindow : NSWindow<NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>

+(instancetype)window;

@property (weak) IBOutlet NSScrollView *chatScrollView;

@property (weak) IBOutlet NSTextField *messageTextField;
@property (weak) IBOutlet NSTableView *messagesTable;

@end
