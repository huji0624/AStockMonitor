//
//  ASEditController.m
//  AStockMonitor
//
//  Created by __huji on 9/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASEditController.h"
#import <Masonry.h>
#import "ASConstant.h"
#import "StocksManager.h"

@interface ASEditController ()
@property (strong) NSTextView *text;
@property (strong) NSButton *save;
@property (strong) NSWindow *aWindow;
@end

@implementation ASEditController

-(instancetype)initWithWindow:(NSWindow *)window{
    self = [super initWithWindow:window];
    if (self) {
        self.aWindow = window;
        [self loadEditViews];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

-(void)loadEditViews{
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSView *stack = self.window.contentView;
    
    NSTextView *text = [[NSTextView alloc] initWithFrame:self.window.contentView.bounds];
    text.editable = YES;
    self.text = text;
    [stack addSubview:text];
    NSArray *stocks = [[NSUserDefaults standardUserDefaults] objectForKey:ASEditTextKey];
    text.string = [stocks componentsJoinedByString:@","];
    [self.window makeFirstResponder:text];
    
    NSButton *save = [[NSButton alloc] initWithFrame:NSMakeRect(self.window.contentView.bounds.size.width/2 - 40, 0, 80, 40 )];
    [save setTitle:@"保存"];
    [save  setTarget:self];
    [save setAction:@selector(saveClick:)];
    self.save = save;
    [stack addSubview:save];
}

-(void)saveClick:(id)sender{
    
    NSArray *strings = [self.text.string componentsSeparatedByString:@","];
    
    [[StocksManager manager] clean];
    [[StocksManager manager] addStocks:strings];
    
    [self.delegate didSaveMonitorStock:strings];
    
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"保存成功，将在下次刷新时生效";
    [alert addButtonWithTitle:@"确定"];
    [alert runModal];
}

@end
