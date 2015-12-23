//
//  LHRealTimeStatistics.h
//  AStockMonitor
//
//  Created by __huji on 23/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LHS(rtsaction) [LHRealTimeStatistics poke:rtsaction]

@interface LHRealTimeStatistics : NSObject
+(void)poke:(NSString*)action;
@end
