//
//  GetStockRequest.m
//  AStockMonitor
//
//  Created by __huji on 16/1/2016.
//  Copyright © 2016 huji. All rights reserved.
//

#import "GetStockRequest.h"
#import "ASFormatCache.h"

@implementation GetStock
@end

@implementation GetStockRequest
-(AFHTTPRequestOperation *)requestForStocks:(NSArray *)stocks block:(GetStockRequestBlock)block{
    NSMutableString *url = [NSMutableString stringWithString:@"http://hq.sinajs.cn/list="];
    NSString *stockString = [stocks componentsJoinedByString:@","];
    [url appendString:stockString];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return [manager GET:url parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = responseObject;
        
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:enc];
        block([self parse:responseString]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        block(nil);
    }];
}
-(GetStock*)parse:(NSString*)text{
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *max = [NSMutableDictionary dictionary];
    
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        if (line.length>0) {
            NSArray *parts = [line componentsSeparatedByString:@"\""];
            if (parts.count>=2) {
                NSArray *item = [parts[1] componentsSeparatedByString:@","];
                
                NSString *first = parts[0];
                NSString *code = [first substringWithRange:NSMakeRange(first.length-9, 8)];
                
                if (item.count>1) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    
                    NSArray *keys = [[ASFormatCache cache] allKeys];
                    for (NSString *key in keys) {
                        NSNumber *index = [[ASFormatCache cache] objectForKey:key];
                        if (index.intValue>=0 && index.intValue < item.count) {
                            [self setDict:key value:item[index.intValue] dict:dict max:max];
                        }
                    }
                    
                    NSString *key = @"股票代码";
                    [self setDict:key value:code dict:dict max:max];
                    
                    [array addObject:dict];
                }
            }
        }
    }
    
    GetStock *stocks = [[GetStock alloc] init];
    stocks.max = max;
    stocks.stocks = array;
    
    return stocks;
}

-(void)setDict:(NSString*)key value:(NSString*)value dict:(NSMutableDictionary*)dict max:(NSMutableDictionary*)max{
    dict[key] = value;
    if (max[key]) {
        NSString *s = dict[key];
        NSString *m = max[key];
        if (s.length>m.length) {
            max[key] = s;
        }
    }else{
        max[key] = dict[key];
    }
}

@end
