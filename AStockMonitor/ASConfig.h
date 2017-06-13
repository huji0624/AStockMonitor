//
//  ASConfig.h
//  AStockMonitor
//
//  Created by __huji on 8/3/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASConfig : NSObject
+(void)startGetConifg;
+(void)doGetConfig:(dispatch_block_t)block;

+(NSString*)as_chat_url;

+(NSString*)as_host;

+(NSString*)as_donations;

+(NSString*)as_donation_conf;

@end
