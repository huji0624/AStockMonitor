//
//  ASTableView.m
//  AStockMonitor
//
//  Created by __huji on 25/5/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASTableView.h"

@interface ASTableView ()
@property (nonatomic) NSStackView *stackView;
@end

@implementation ASTableView{
//    CGFloat _startY;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _startY = 0;
        
        self.stackView = [[NSStackView alloc] init];
        self.stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
        self.stackView.spacing = 0;
        self.stackView.alignment = NSLayoutAttributeLeft;
        [self setDocumentView:self.stackView];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)insertView:(NSView *)view{
    
    [self.stackView addView:view inGravity:NSStackViewGravityBottom];
    
    self.stackView.frame = NSMakeRect(0, 0, self.frame.size.width, self.stackView.frame.size.height + view.frame.size.height);
}

@end
