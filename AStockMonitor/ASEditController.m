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

@interface ASEditController ()
@property (strong) NSTextView *text;
@property (strong) NSButton *save;
@end

@implementation ASEditController

-(instancetype)initWithWindow:(NSWindow *)window{
    self = [super initWithWindow:window];
    if (self) {
        [self loadEditViews];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

-(void)loadEditViews{
    CGFloat margin = 50;
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSView *stack = self.window.contentView;
    
    NSTextView *text = [[NSTextView alloc] initWithFrame:self.window.contentView.bounds];
    text.editable = YES;
    self.text = text;
    [stack addSubview:text];
    text.string = [[NSUserDefaults standardUserDefaults] objectForKey:ASEditTextKey];
    [self.window makeFirstResponder:text];
    
    NSButton *save = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 80, margin - 4 )];
    [save setTitle:@"保存"];
    [save  setTarget:self];
    [save setAction:@selector(saveClick:)];
    self.save = save;
    [stack addSubview:save];
}

-(void)saveClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:self.text.string forKey:ASEditTextKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate didSaveMonitorStock:self.text.string];
}

@end
