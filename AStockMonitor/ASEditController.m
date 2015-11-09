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
@property (strong) NSStackView *stack;
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
    NSStackView *stack = [[NSStackView alloc] initWithFrame:self.window.contentView.bounds];
    self.stack =stack;
    stack.orientation = NSUserInterfaceLayoutOrientationVertical;
    [self.window.contentView addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window.contentView);
    }];
    
    NSTextView *text = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, stack.bounds.size.width, stack.bounds.size.height - margin )];
    text.editable = YES;
    [stack addView:text inGravity:NSStackViewGravityTop];
    self.text = text;
    
    text.string = [[NSUserDefaults standardUserDefaults] objectForKey:ASEditTextKey];
    
    NSButton *save = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 80, margin - 4 )];
    save.bezelStyle = NSRoundedBezelStyle;
    [save  setTarget:self];
    [save setAction:@selector(saveClick:)];
    
    self.save = save;
    
    [stack addView:save inGravity:NSStackViewGravityTop];
}

-(void)saveClick:(id)sender{
    [[NSUserDefaults standardUserDefaults] setObject:self.text.string forKey:ASEditTextKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate didSaveMonitorStock:self.text.string];
}

@end
