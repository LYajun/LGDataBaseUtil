//
//  LGDataBaseUtil.h
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMObject+LGJson.h"
#import <Realm/Realm.h>

#define LG_DBUtil [LGDataBaseUtil shareInstance]
@interface LGDataBaseUtil : NSObject

+ (LGDataBaseUtil *)shareInstance;
/** 数据库路径 */
- (NSString *)dbFilePath;
/** 创建数据库 */
- (void)createDataBaseWithName:(NSString *) name;
/* 增 */
- (void)addRLMObject:(RLMObject *)obj;
/* 删 */
/** 删 单条记录*/
- (void)deleteWithRLMObjectClass:(Class) Obj primaryKey:(NSString *)primaryKey;
- (void)deleteRLMObject:(RLMObject *)obj;
/** 删 多条记录*/
- (void)deleteRLMObjects:(NSArray<RLMObject *> *)objs;
/** 删 所有记录*/
- (void)deleteAllObjects;
/* 改 */

/** 改 针对单个数据进行的修改或新增
 方法的前提是有主键,方法会先去主键里面找有没有字典里面传入的主键的记录，如果有就更新该条数据
 注意：所有的值都必须有，如果有哪几个值是null，那么就会覆盖原来已经有的值，这样就会出现数据丢失的问题*/
- (void)updateRLMObject:(RLMObject *)obj;
/** 改 针对单个数据进行的修改或新增
 方法的前提是有主键，方法会先去主键里面找有没有字典里面传入的主键的记录，如果有，就只更新字典里面的子集。如果没有，就新建一条记录*/
- (void)updateInRLMObject:(Class)Obj value:(NSDictionary *)value;
/** 改 针对一组数据的修改或新增*/
- (void)updateRLMObjects:(NSArray<RLMObject *> *)objs;

/* 查 */
/** 查 全部数据*/
- (RLMResults *)selectAllObjectsInRLMObjectClass:(Class) Obj;
/** 查 主键查询*/
- (RLMResults *)selectWithRLMObjectClass:(Class) Obj primaryKey:(NSString *)primaryKey;
/** 查 多参数查询：@{@"key1":@"value1",...}*/
- (RLMResults *)selectWithRLMObjectClass:(Class) Obj parameter:(NSDictionary *) parameter;
/** 查 条件查询：where = @"key1 = 'value1' AND key2 = 'value2'"*/
- (RLMResults *)selectWithRLMObjectClass:(Class) Obj where:(NSString *) where;
/** 查 谓词查询: predicate = [NSPredicate predicateWithFormat:@"key1 = %@ AND key2 = %@",
 value1, value2]*/
- (RLMResults *)selectWithRLMObjectClass:(Class) Obj predicate:(NSPredicate *) predicate;
/** 查 条件排序：property = key*/
- (RLMResults *)sortWithRLMResults:(RLMResults *) results sortedProperty:(NSString *)property ascending:(BOOL)ascending;
@end
