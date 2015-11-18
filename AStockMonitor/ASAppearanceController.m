//
//  ASAppearanceController.m
//  AStockMonitor
//
//  Created by __huji on 18/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASAppearanceController.h"
#import "ASConstant.h"

@interface ASAppearanceController ()
@property (weak) IBOutlet NSSlider *slider;
@end

@implementation ASAppearanceController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)awakeFromNib{
    NSNumber *alpha = [[NSUserDefaults standardUserDefaults] objectForKey:ASAlphaValueKey];
    self.slider.floatValue = alpha.floatValue*100;
}

-(IBAction)alphaChange:(id)sender{
    NSSlider *slider = sender;
    CGFloat alpha = slider.floatValue/100.0f;
    [[NSUserDefaults standardUserDefaults] setObject:@(alpha) forKey:ASAlphaValueKey];
    self.alphaTargetView.alphaValue = alpha;
}

@end
