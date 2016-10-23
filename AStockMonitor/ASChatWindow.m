//
//  ASChatWindow.m
//  AStockMonitor
//
//  Created by __huji on 23/10/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASChatWindow.h"
#import "ChatMessageCell.h"

static ASChatWindow *_instance = nil;

@interface ASChatWindow ()
@property (nonatomic,strong) NSMutableArray *messages;
@property (nonatomic,strong) NSImage *no_avatarImg;
@end

@implementation ASChatWindow

+(instancetype)window{
    return _instance;
}

-(void)awakeFromNib{
    if (!_instance) {
        _instance = self;
    }
    
    if (self.messages==nil) {
         self.messages = [NSMutableArray array];
    }
    
    if (self.no_avatarImg==nil) {
        NSImage *img = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no-avatar" ofType:@"png"]];
        self.no_avatarImg = img;
    }
    
    self.messagesTable.delegate = self;
    self.messagesTable.dataSource = self;
    self.messageTextField.delegate = self;
}

- (void)tableViewColumnDidResize:(NSNotification *)aNotification
{
    NSRange visibleRows = [self.messagesTable rowsInRect:self.chatScrollView.contentView.bounds];
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0];
    [self.messagesTable noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:visibleRows]];
    [NSAnimationContext endGrouping];
}

-(void)reloadData
{
    [self.messagesTable reloadData];
    if ([self.messagesTable numberOfRows] > 0)
        [self.messagesTable scrollRowToVisible:[self.messagesTable numberOfRows] - 1];
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.messages count];
}

-(NSString*)textForRow:(NSInteger)row{
    return [self.messages objectAtIndex:row];
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    NSString *text = [self textForRow:row];
    NSTableColumn *tableColoumn = [self.messagesTable tableColumnWithIdentifier:@"MessageColumn"];
    NSRect stringRect = [text boundingRectWithSize:CGSizeMake([tableColoumn width]-139, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[NSFont systemFontOfSize:12]} context:nil];
    
    CGFloat heightOfRow = stringRect.size.height+10.0f;
    return (heightOfRow<46.0f)?50.0f:heightOfRow;
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    return NO;
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    ChatMessageCell *cellView = [tableView makeViewWithIdentifier:@"MessageCell" owner:self];
    cellView.avatarImageView.image = self.no_avatarImg;
    [cellView setDate:@"date"];
    [cellView.textView setString:[self textForRow:row]];
//    [cellView.removeButton setHidden:!(message.my.boolValue || [[Chat shared] moderatorMode])];
//    [cellView.avatarButton setAction:@selector(openUserProfile:)];
    return cellView;
}

-(void)controlTextDidEndEditing:(NSNotification *)notification
{
    if([[[notification userInfo] objectForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement)
    {
        [self.messages addObject:self.messageTextField.stringValue];
        self.messageTextField.stringValue = @"";
        
        [self reloadData];
        NSLog(@"[[Chat shared] didSendMessageRequest];");
    }
}

@end
