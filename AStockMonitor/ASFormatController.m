//
//  ASFormatController.m
//  AStockMonitor
//
//  Created by __huji on 21/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASFormatController.h"
#import "ASFormatCache.h"

@interface ASFormatController ()
@property (strong) IBOutlet NSTextView *formatKeysLabel;
@property (weak) IBOutlet NSTextField *formatEditor;
@end

@implementation ASFormatController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

-(void)awakeFromNib{
    self.formatKeysLabel.editable = NO;
    
    NSArray *keys = [[ASFormatCache cache] allKeys];
    
    NSMutableString *string = [NSMutableString stringWithString:@"可用字段：\n\n"];
    
    int count = 0;
    for (NSString *key in keys) {
        [string appendString:key];
        [string appendString:@"     "];
        count++;
        if (count>5) {
            count = 0;
            [string appendString:@"\n"];
        }
    }
    
    self.formatKeysLabel.string = string;
    
    self.formatEditor.stringValue = [[ASFormatCache cache] currentFormat];
}

-(NSString*)checkFormat:(NSString*)fms{
    NSArray *f = [fms componentsSeparatedByString:ASFormatSep];
    for (NSString *key in f) {
        if (![[ASFormatCache cache] objectForKey:key]) {
            return [NSString stringWithFormat:@"没有这个数据 %@",key];
        }
    }
    return nil;
}

-(IBAction)saveFormatClick:(id)sender{
    NSString *er = [self checkFormat:self.formatEditor.stringValue];
    if (er) {
        NSAlert *alert = [[NSAlert alloc] init];
        alert.messageText = er;
        [alert runModal];
        return;
    }
    
    
    [[ASFormatCache cache] saveCurrentFormat:self.formatEditor.stringValue];
    
    [self close];
}

@end