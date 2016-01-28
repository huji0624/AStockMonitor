//
//  ExcuteTimesCache.h
//  DiSpecialDriver
//
//  Created by __huji on 31/8/15.
//  Copyright (c) 2015 huji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ExcuteTimesBlock)(NSUInteger timesIndex);//return YES to minus showtimes 1.return NO do noting.

@interface ExcuteTimesCache : NSObject
+(void)excute:(NSString*)key showTimes:(NSUInteger)times action:(ExcuteTimesBlock)block;//default to file.

+(void)minusTimes:(NSUInteger)times forKey:(NSString*)key;
@end
