//
//  ASStockView.h
//  AStockMonitor
//
//  Created by __huji on 25/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ASStockViewDelegate <NSObject>
-(void)didClickInfo:(id)tag;
@end

@interface ASStockView : NSView
@property id stockTag;
@property (weak) id<ASStockViewDelegate> delegate;
-(instancetype)initWithInfo:(NSAttributedString*)info;
@end
