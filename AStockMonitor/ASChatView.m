//
//  ASChatView.m
//  AStockMonitor
//
//  Created by __huji on 25/5/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASChatView.h"
#import "ASTableView.h"

//@interface ASMsg : NSObject
//@property (copy) NSString *from;
//@property (copy) NSString *msg;
//@end
//@implementation ASMsg
//@end

@interface ASChatView ()<NSTableViewDataSource>

@end

@implementation ASChatView{
    ASTableView *_tableView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableView = [[ASTableView alloc] init];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}

-(void)addMessage:(NSString *)from msg:(NSString *)msgtext{
    
//    NSTableColumn *column=[[NSTableColumn alloc] initWithIdentifier:@"msg"];
//    [[column headerCell] setStringValue:msg];
//    [[column headerCell] setAlignment:NSCenterTextAlignment];
////    [column setWidth:100.0];
//    [column setMinWidth:50];
//    [column setEditable:NO];
//    [column setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
//    
//    [_tableView addTableColumn:column];
    
//    ASMsg *msg = [[ASMsg alloc] init];
//    msg.from = from;
//    msg.msg = msgtext;
    
    NSTextField *text = [[NSTextField alloc] init];
    text.editable = NO;
    text.translatesAutoresizingMaskIntoConstraints = NO;
    text.alignment = NSTextAlignmentCenter;
    text.bordered = YES;
    text.stringValue = [NSString stringWithFormat:@"%@ : %@",from,msgtext];

    CGSize size = [self sizeForText:text.stringValue fontSize:16 mw:_tableView.frame.size.width mh:9999];
    NSRect rect = text.frame;
    rect.size = size;
    text.frame = rect;
    
    [_tableView insertView:text];
}

-(CGSize)sizeForText:(NSString*)text fontSize:(CGFloat)fs mw:(CGFloat)mw mh:(CGFloat)mh{
    NSFont *font = [NSFont systemFontOfSize:fs];
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(mw, mh) options:options attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
