//
//  ASQRMoneyController.m
//  AStockMonitor
//
//  Created by __huji on 23/5/2017.
//  Copyright © 2017 huji. All rights reserved.
//

#import "ASQRMoneyController.h"
#import "ASConfig.h"

@interface ASQRMoneyController ()

@end

@implementation ASQRMoneyController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.donations.editable = NO;
}

-(void)showWindow:(id)sender{
    [super showWindow:sender];
    
    NSString *d = [ASConfig as_donations];
    if(d) self.donations.string = d;
    
    [ASConfig doGetConfig:^(ConfigModel *model) {
        NSString *donations = [model as_donations];
        if (donations) {
            self.donations.string = donations;
        }
    }];
}

@end
