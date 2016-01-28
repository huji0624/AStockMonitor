//
//  ExcuteTimesCache.m
//  DiSpecialDriver
//
//  Created by __huji on 31/8/15.
//  Copyright (c) 2015 huji. All rights reserved.
//

#import "ExcuteTimesCache.h"

@implementation ExcuteTimesCache
+(void)excute:(NSString *)key showTimes:(NSUInteger)times action:(ExcuteTimesBlock)block{
    [self excute:key showTimes:times action:block toFile:YES];
}
+(void)excute:(NSString *)key showTimes:(NSUInteger)times action:(ExcuteTimesBlock)block toFile:(BOOL)toFile{
    
    NSString *customeKey = [self customeKey:key];
    
    NSUserDefaults *stand = [NSUserDefaults standardUserDefaults];
    NSNumber *oldTimes = [stand objectForKey:customeKey];
    if (oldTimes==nil) {
        oldTimes = @(times);
        [stand setObject:@(times) forKey:customeKey];
        [stand synchronize];
    }
    if (oldTimes.integerValue>0) {
        NSNumber *newTimes = nil;
        
        if (block) {
            BOOL ret = block(times - oldTimes.integerValue);
            if (ret) {
                newTimes = @(oldTimes.integerValue - 1);
            }
        }
        
        if (newTimes) {
            [stand setObject:newTimes forKey:customeKey];
            [stand synchronize];
        }
    }
}

+(void)minusTimes:(NSUInteger)times forKey:(NSString *)key{
    NSString *customeKey = [self customeKey:key];
    NSUserDefaults *stand = [NSUserDefaults standardUserDefaults];
    NSNumber *oldTimes = [stand objectForKey:customeKey];
    NSNumber *newTimes = @(oldTimes.integerValue - times);
    [stand setObject:newTimes forKey:customeKey];
    [stand synchronize];
}

+(NSString*)customeKey:(NSString*)key{
    return [@"ExcuteTimesCache_Key_" stringByAppendingString:key];
}

@end
