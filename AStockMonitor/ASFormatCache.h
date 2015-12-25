//
//  ASFormatCache.h
//  AStockMonitor
//
//  Created by __huji on 21/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ASDefaultFormat @"股票名字"
#define ASFormatSep @"-"

@interface ASFormatCache : NSObject
+(instancetype)cache;

-(NSArray*)allKeys;
-(NSNumber*)objectForKey:(NSString*)key;

-(NSString*)currentFormat;
-(void)saveCurrentFormat:(NSString*)string;

@end
