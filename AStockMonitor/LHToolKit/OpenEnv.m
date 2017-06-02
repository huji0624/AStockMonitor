//
//  OpenEnv.m
//  DeskTest
//
//

#import "OpenEnv.h"

typedef CGFloat (^NoneIDBlock)(id params);
typedef id (^IDBlock)(id params);

@interface OpenEnvtor : NSObject
@property (nonatomic,strong) NSString *key;
@property (nonatomic,weak) id target;

@property (nonatomic,strong) NoneIDBlock nonIDblock;
@property (nonatomic,strong) IDBlock iDblock;

@end
@implementation OpenEnvtor
@end

@interface OpenEnv ()
@property (nonatomic,strong) NSMutableDictionary *envtors;
@end

static OpenEnv *_instance = nil;

@implementation OpenEnv
+(instancetype)env{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[OpenEnv alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.envtors = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)removeEnv:(NSString *)key{
    [self.envtors removeObjectForKey:key];
}

-(void)removeEnvIn:(id)target{
    NSArray *keys = [NSArray arrayWithArray:self.envtors.allKeys];
    NSMutableArray *rmkeys = [NSMutableArray arrayWithCapacity:keys.count];
    for (NSString *key in keys) {
        OpenEnvtor *et = [self.envtors objectForKey:key];
        if (et.target == target) {
            [rmkeys addObject:key];
        }
    }
    
    [self.envtors removeObjectsForKeys:rmkeys];
}

//----get
-(CGFloat)getNoneIDResult:(NSString*)key params:(id)params defaultValue:(CGFloat)def{
    OpenEnvtor *et = [self.envtors objectForKey:key];
    if (et) {
        if (et.target) {
            return et.nonIDblock(params);
        }else{
            [self removeEnv:key];
            return def;
        }
    }else{
        return def;
    }
}

-(BOOL)getBOOL:(NSString *)key defaultValue:(BOOL)def{
    return [self getNoneIDResult:key params:nil defaultValue:def];
}

-(NSInteger)getInt:(NSString *)key defaultValue:(NSInteger)def{
    return [self getNoneIDResult:key params:nil defaultValue:def];
}

-(CGFloat)getFloat:(NSString *)key defaultValue:(CGFloat)def{
    return [self getNoneIDResult:key params:nil defaultValue:def];
}

-(id)getIDResult:(NSString*)key params:(id)params defaultValue:(id)def{
    OpenEnvtor *et = [self.envtors objectForKey:key];
    if (et) {
        if (et.target) {
            return et.iDblock(params);
        }else{
            [self removeEnv:key];
            return def;
        }
    }else{
        return def;
    }
}

-(NSString *)getString:(NSString *)key defaultValue:(NSString *)def{
    return [self getIDResult:key params:nil defaultValue:def];
}

-(NSString *)getString:(NSString *)key params:(id)params defaultValue:(NSString *)def{
    return [self getIDResult:key params:params defaultValue:def];
}

-(NSArray *)getArray:(NSString *)key defaultValue:(NSArray*)def{
    return [self getIDResult:key params:nil defaultValue:def];
}

-(NSDictionary *)getDic:(NSString *)key defaultValue:(NSDictionary *)def{
    return [self getIDResult:key params:nil defaultValue:def];
}

-(NSDictionary *)getDic:(NSString *)key params:(id)params defaultValue:(NSDictionary *)def{
    return [self getIDResult:key params:params defaultValue:def];
}

-(id)getID:(NSString *)key defaultValue:(id)def{
    return [self getIDResult:key params:nil defaultValue:def];
}

-(id)getID:(NSString *)key params:(id)params defaultValue:(id)def{
    return [self getIDResult:key params:params defaultValue:def];
}


//----add
-(void)addEnvtor:(NSString*)key target:(id)t call:(NoneIDBlock)call IDCall:(IDBlock)IDCall{
    OpenEnvtor *oldet = self.envtors[key];
    if (oldet && oldet.target) {
        return;
    }
    
    OpenEnvtor *et = [[OpenEnvtor alloc] init];
    et.key = key;
    et.target = t;
    et.nonIDblock = call;
    et.iDblock = IDCall;
    
    [self.envtors setObject:et forKey:key];
}

-(void)addEnvBOOL:(NSString *)key target:(id)t call:(BOOL (^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:^CGFloat(id params) {
        return call(params);
    } IDCall:nil];
}

-(void)addEnvInt:(NSString *)key target:(id)t call:(NSInteger (^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:^CGFloat(id params) {
        return call(params);
    } IDCall:nil];
}

-(void)addEnvFloat:(NSString *)key target:(id)t call:(CGFloat (^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:^CGFloat(id params) {
        return call(params);
    } IDCall:nil];
}

-(void)addEnvDic:(NSString *)key target:(id)t call:(NSDictionary *(^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:nil IDCall:^id(id params) {
        return call(params);
    }];
}

-(void)addEnvArray:(NSString *)key target:(id)t call:(NSArray *(^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:nil IDCall:^id(id params) {
        return call(params);
    }];
}

-(void)addEnvString:(NSString *)key target:(id)t call:(NSString *(^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:nil IDCall:^id(id params) {
        return call(params);
    }];
}

-(void)addEnvID:(NSString *)key target:(id)t call:(id (^)(id params))call des:(NSString *)description{
    if (!t) {
        return;
    }
    
    if (!call) {
        return;
    }
    
    
    [self addEnvtor:key target:t call:nil IDCall:^id(id params) {
        return call(params);
    }];
}

@end
