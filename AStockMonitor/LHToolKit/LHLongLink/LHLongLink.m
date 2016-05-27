//
//  LHLongLink.m
//  AStockMonitor
//
//  Created by __huji on 31/3/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "LHLongLink.h"
#import "Pomelo.h"

static LHLongLink *_instance = nil;

@interface LHLongLink ()<PomeloDelegate>

@end

@implementation LHLongLink{
    Pomelo *_pomelo;
    LHLongLinkConnectBlock _connectCallBack;
}

+(instancetype)link{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LHLongLink alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pomelo = [[Pomelo alloc] initWithDelegate:self];
    }
    return self;
}

-(void)PomeloDidConnect:(Pomelo *)pomelo{
    if (_connectCallBack) {
        _connectCallBack(LHLongLinkConnectOK);
    }
}

-(void)PomeloDidDisconnect:(Pomelo *)pomelo withError:(NSError *)error{
    if (_connectCallBack && error) {
        _connectCallBack(LHLongLinkConnectFail);
    }
    
    NSLog(@"pomelo disconnect.");
}

-(void)connect:(LHLongLinkConfig *)config callback:(LHLongLinkConnectBlock)block{
    _connectCallBack = block;
    
    [_pomelo connectToHost:config.host onPort:config.port];
}

-(void)send:(NSString *)route params:(NSDictionary *)params{
    [_pomelo notifyWithRoute:route andParams:params];
}

-(void)request:(NSString *)route params:(NSDictionary *)params callback:(LHLongLinkEventBlock)callback{
    [_pomelo requestWithRoute:route andParams:params andCallback:^(id d) {
        if (callback) {
            callback(d);
        }
    }];
}

-(void)disconnect{
    [_pomelo disconnect];
}

-(void)onRoute:(NSString *)route withCallback:(LHLongLinkEventBlock)block{
    [_pomelo onRoute:route withCallback:^(id callback) {
        block(callback);
    }];
}

@end
