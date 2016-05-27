//
//  LHLongLink.h
//  AStockMonitor
//
//  Created by __huji on 31/3/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHLongLinkConfig.h"

typedef enum{
    LHLongLinkConnectOK,
    LHLongLinkConnectFail
} LHLongLinkConnectRet;

typedef void(^LHLongLinkConnectBlock)(LHLongLinkConnectRet ret);

typedef void(^LHLongLinkEventBlock)(id data);

@interface LHLongLink : NSObject
+(instancetype)link;

-(void)connect:(LHLongLinkConfig*)config callback:(LHLongLinkConnectBlock)block;

-(void)send:(NSString*)route params:(NSDictionary*)params;
-(void)request:(NSString*)route params:(NSDictionary*)params callback:(LHLongLinkEventBlock)callback;

- (void)onRoute:(NSString *)route withCallback:(LHLongLinkEventBlock)block;

-(void)disconnect;

@end
