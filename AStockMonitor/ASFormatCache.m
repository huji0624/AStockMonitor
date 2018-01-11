//
//  ASFormatCache.m
//  AStockMonitor
//
//  Created by __huji on 21/11/15.
//  Copyright © 2015 huji. All rights reserved.
//

#import "ASFormatCache.h"

#define AS_CurrentFormatKey @"ascuFormate"

static ASFormatCache *_instance =nil;
@implementation ASFormatCache{
    NSDictionary *_formatTable;
    NSUserDefaults *_ud;
}

+(instancetype)cache{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ASFormatCache alloc] init];
    });
    return _instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _formatTable = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"formatTable" ofType:@"plist"]];
        _ud = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(NSArray *)allKeys{
    NSMutableSet *keys = [NSMutableSet set];
    NSArray *marketkeys = _formatTable.allKeys;
    for (NSString *mkey in marketkeys) {
        NSDictionary *tmp = _formatTable[mkey];
        [keys addObjectsFromArray:tmp.allKeys];
    }
    return keys.allObjects;
}

-(NSNumber *)objectForKey:(NSString *)key market:(NSString*)market{
    NSDictionary *tmp = _formatTable[market];
    return tmp[key];
}

-(NSString *)currentFormat{
    NSString *fm = [_ud objectForKey:AS_CurrentFormatKey];
    if (fm == nil) {
        return ASDefaultFormat;
    }
    return fm;
}

-(void)saveCurrentFormat:(NSString *)string{
    [_ud setObject:string forKey:AS_CurrentFormatKey];
}

@end
