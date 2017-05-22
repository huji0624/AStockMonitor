//
//  GetStockRequest.h
//  AStockMonitor
//
//  Created by __huji on 16/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>

@interface GetStock : NSObject
@property (nonatomic,strong) NSDictionary *max;
@property (nonatomic,strong) NSArray *stocks;
@end

typedef void(^GetStockRequestBlock)(GetStock *stocks);

@interface GetStockRequest : NSObject
-(AFHTTPRequestOperation *)requestForStocks:(NSArray*)stocks block:(GetStockRequestBlock)block;
@end
