//
//  StocksManager.m
//  AStockMonitor
//
//  Created by __huji on 15/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "StocksManager.h"
#import "ASConstant.h"

static StocksManager *_instance = nil;

@interface StocksManager ()
@property (nonatomic,strong) NSMutableArray *cacheStocks;
@end

@implementation StocksManager
+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[StocksManager alloc] init];
    });
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheStocks = [NSMutableArray array];
        
        NSArray* st = [[NSUserDefaults standardUserDefaults] objectForKey:ASEditTextKey];
        if (!st) {
            [self.cacheStocks addObjectsFromArray: @[@"sh000001",@"sz399001"]];
        }else{
            [self.cacheStocks addObjectsFromArray:st];
        }
    }
    return self;
}
-(void)clean{
    [self.cacheStocks removeAllObjects];
}
-(void)addStocks:(NSArray *)stocks{
    [self.cacheStocks addObjectsFromArray:stocks];
    
    [self synchronize];
}
-(void)removeStock:(NSString *)stock{
    for (NSString *tmp in self.stocks) {
        if ([stock isEqualToString:tmp]) {
            [self.cacheStocks removeObject:tmp];
        }
    }
    
    [self synchronize];
}
-(NSArray *)stocks{
    return [NSArray arrayWithArray:self.cacheStocks];
}
-(void)synchronize{
    [[NSUserDefaults standardUserDefaults] setObject:self.cacheStocks forKey:ASEditTextKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
