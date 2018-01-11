//
//  ASConfig.h
//  AStockMonitor
//
//  Created by __huji on 8/3/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface ConfigModel : JSONModel
@property (nonatomic,copy) NSString *as_chat_url;
@property (nonatomic,copy) NSString *as_donations;
@property (nonatomic,copy) NSString *as_donation_conf;
@end

typedef void(^GetConfigBlock)(ConfigModel *model);

@interface ASConfig : NSObject
+(void)startGetConifg;
+(void)doGetConfig:(GetConfigBlock)block;

+(NSString*)as_chat_url;

+(NSString*)as_host;

+(NSString*)as_donations;

+(NSString*)as_donation_conf;

@end
