//
//  ASEditController.h
//  AStockMonitor
//
//  Created by __huji on 9/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ASEditDelegate <NSObject>

-(void)didSaveMonitorStock:(NSArray*)stocks;

@end

@interface ASEditController : NSWindowController
@property (weak) id<ASEditDelegate> delegate;
@end
