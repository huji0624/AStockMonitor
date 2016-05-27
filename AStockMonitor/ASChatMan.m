//
//  ASChatMan.m
//  AStockMonitor
//
//  Created by __huji on 25/5/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "ASChatMan.h"
#import "LHLongLink.h"

ASChatMan *_instance = nil;

@implementation ASChatMan
{
    NSInteger _userCount;
}

+(instancetype)man{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ASChatMan alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userCount = 0;
    }
    return self;
}

-(void)connectChat{
    
    LHLongLinkConfig *config = [[LHLongLinkConfig alloc] init];
    config.host = @"123.56.46.78";
    config.port = 3014;
    [[LHLongLink link] connect:config callback:^(LHLongLinkConnectRet ret) {
        if (ret == LHLongLinkConnectOK) {
            
            [[LHLongLink link] request:@"gate.gateHandler.queryEntry" params:@{@"uid":@"mach"} callback:^(id data) {
                NSDictionary *dict = data;
                NSNumber *code = [dict objectForKey:@"code"];
                if (code.integerValue == 200) {
                    
                    NSString *host = dict[@"host"];
                    NSNumber *port = dict[@"port"];
                    
                    [[LHLongLink link] disconnect];
                    
                    LHLongLinkConfig *chatconfig = [[LHLongLinkConfig alloc] init];
                    chatconfig.host = host;
                    chatconfig.port = port.integerValue;
                    [[LHLongLink link] connect:chatconfig callback:^(LHLongLinkConnectRet ret) {
                        if (ret == LHLongLinkConnectOK) {
                            NSLog(@"connect chat ok.");
                            
                            [[LHLongLink link] request:@"connector.entryHandler.enter" params:@{@"username":@"mach",@"rid":@"ghoststock"} callback:^(id data) {
                                NSLog(@"enter:%@",data);
                                NSDictionary *dict = data;
                                NSArray *users = dict[@"users"];
                                _userCount = users.count;
                                
                                [self registerEvents];
                            }];
                            
                        }else{
                            NSLog(@"connect chat fail.");
                        }
                    }];
                    
                }else{
                    NSLog(@"err code %@",code);
                }
            }];
            
        }else{
            NSLog(@"connect gate fail.");
        }
    }];
    
}

-(void)registerEvents{
    
    [[LHLongLink link] onRoute:@"onChat" withCallback:^(id data) {
        
    }];
    
    [[LHLongLink link] onRoute:@"onAdd" withCallback:^(id data) {
        _userCount ++;
    }];
    
    [[LHLongLink link] onRoute:@"onLeave" withCallback:^(id data) {
        _userCount --;
    }];
}

@end
