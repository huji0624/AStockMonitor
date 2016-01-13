//
//  LHRealTimeStatistics.m
//  AStockMonitor
//
//  Created by __huji on 23/12/2015.
//  Copyright © 2015 huji. All rights reserved.
//

#import "LHRealTimeStatistics.h"
#import <AFHTTPRequestOperationManager.h>

@implementation LHRealTimeStatistics
+(void)poke:(NSString *)action{
    if (!action) {
        return;
    }
    
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:action forKey:@"action"];
    [dict setObject:bid forKey:@"appid"];
    
    NSString *uuid = [self getUUID];
    if (uuid) {
        [dict setObject:uuid forKey:@"uuid"];
    }
    
    NSString *url = @"http://luckylog.sinaapp.com";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:dict  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"poke %@",action);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

+ (NSString*)getUUID{
    NSString *uuid = [self getHwUUID];
    if (!uuid) {
        uuid = [self getSystemSerialNumber];
    }
    return uuid;
}

// Hardare UUID shows in the system profiler.
+ (NSString *)getHwUUID
{
    CFUUIDBytes uuidBytes;
    CFUUIDRef   uuid;
    CFStringRef uuidString;
    
    gethostuuid((unsigned char *)&uuidBytes, &(const struct timespec){0, 0});
    uuid        = CFUUIDCreateFromUUIDBytes(kCFAllocatorDefault, uuidBytes);
    uuidString  = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    if (uuid) CFRelease(uuid);
    return CFBridgingRelease(uuidString);
}

// Hardware serial number shows in "About this Mac" window.
+ (NSString *)getSystemSerialNumber
{
    CFStringRef     serialNumber;
    io_service_t    ioPlatformExpertDevice;
    
    serialNumber = NULL;
    ioPlatformExpertDevice = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                         IOServiceMatching("IOPlatformExpertDevice"));
    
    if (ioPlatformExpertDevice) {
        
        CFTypeRef serialNumberCFString;
        serialNumberCFString = IORegistryEntryCreateCFProperty(ioPlatformExpertDevice,
                                                               CFSTR(kIOPlatformSerialNumberKey),
                                                               kCFAllocatorDefault,
                                                               0);
        if (serialNumberCFString) serialNumber = serialNumberCFString;
        IOObjectRelease(ioPlatformExpertDevice);
    }
    return CFBridgingRelease(serialNumber);
}

@end
