//
//  GetStockRequest.h
//  AStockMonitor
//
//  Created by __huji on 16/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>

typedef void(^GetStockRequestBlock)(NSArray *stocks);

@interface GetStockRequest : NSObject
-(AFHTTPRequestOperation *)requestForStocks:(NSArray*)stocks block:(GetStockRequestBlock)block;
@end
