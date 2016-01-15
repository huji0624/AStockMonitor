//
//  StocksManager.h
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StocksManager : NSObject
+(instancetype)manager;

-(void)clean;

-(void)addStocks:(NSArray*)stocks;
-(void)removeStock:(NSString*)stock;

-(NSArray*)stocks;

@end
