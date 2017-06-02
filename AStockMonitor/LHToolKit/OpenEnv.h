//
//  OpenEnv.h
//  DeskTest
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define OPEV [OpenEnv env]

/*
 查询当前环境状态.
 */
@interface OpenEnv : NSObject

+(instancetype)env;

/*
 查询环境值
 default 表示如果不存在返回的默认值
 */
-(BOOL)getBOOL:(NSString*)key defaultValue:(BOOL)def;
-(NSInteger)getInt:(NSString*)key defaultValue:(NSInteger)def;
-(CGFloat)getFloat:(NSString*)key defaultValue:(CGFloat)def;
-(NSArray*)getArray:(NSString*)key defaultValue:(NSArray*)def;

-(NSDictionary*)getDic:(NSString*)key defaultValue:(NSDictionary*)def;
-(NSDictionary*)getDic:(NSString*)key params:(id)params defaultValue:(NSDictionary*)def;

-(NSString*)getString:(NSString*)key defaultValue:(NSString*)def;
-(NSString*)getString:(NSString*)key params:(id)params defaultValue:(NSString*)def;

-(id)getID:(NSString*)key defaultValue:(id)def;
-(id)getID:(NSString*)key params:(id)params defaultValue:(id)def;


/*
 提供对应的环境值
 target     target会被以weak引用，当target内存被回收时，会自动remove这个key
 description    不会被运行使用，填写该key和返回值的描述，用于生成文档
 */
-(void)addEnvBOOL:(NSString*)key target:(id)t call:(BOOL (^)(id params))call des:(NSString*)description;
-(void)addEnvInt:(NSString*)key target:(id)t call:(NSInteger (^)(id params))call des:(NSString*)description;
-(void)addEnvFloat:(NSString*)key target:(id)t call:(CGFloat (^)(id params))call des:(NSString*)description;
-(void)addEnvString:(NSString*)key target:(id)t call:(NSString* (^)(id params))call des:(NSString*)description;
-(void)addEnvArray:(NSString*)key target:(id)t call:(NSArray* (^)(id params))call des:(NSString*)description;
-(void)addEnvDic:(NSString*)key target:(id)t call:(NSDictionary* (^)(id params))call des:(NSString*)description;
-(void)addEnvID:(NSString*)key target:(id)t call:(id (^)(id params))call des:(NSString*)description;

/*
 主动remove某个key
 */
-(void)removeEnv:(NSString*)key;

/*
 主动remove某个target上
 */
-(void)removeEnvIn:(id)target;

@end
