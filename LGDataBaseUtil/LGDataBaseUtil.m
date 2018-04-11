//
//  LGDataBaseUtil.m
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "LGDataBaseUtil.h"

@interface LGDataBaseUtil ()

@end
@implementation LGDataBaseUtil
#pragma mark public
+ (LGDataBaseUtil *)shareInstance{
    static LGDataBaseUtil * macro = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        macro = [[LGDataBaseUtil alloc]init];
    });
    return macro;
}
- (void)createDataBaseWithName:(NSString *) name{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:name];
    
    RLMRealmConfiguration *config = self.realmConfig;
    config.fileURL = [[NSURL alloc] initFileURLWithPath:dbPath];
    config.readOnly = NO;
    int currentVersion = 1.0;
    config.schemaVersion = currentVersion;
    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion < currentVersion) {
        }
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    NSError *createError;
    [RLMRealm realmWithConfiguration:config error:&createError];
    if (createError) {
        NSLog(@"创建数据库失败:%@",createError);
    }
}

- (NSString *)dbFilePath{
    return self.realmConfig.fileURL.path;
}

/* 增 */
- (void)addRLMObject:(RLMObject *)obj{
    Class Obj = [self rlmClassFromRLMObject:obj];
    if (![self selectIsExistWithRLMObjectClass:Obj primaryKey:[obj valueForKeyPath:[Obj primaryKey]]]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm transactionWithBlock:^{
                [realm addObject: obj];
            }];
        });
    }else{
        NSLog(@"添加数据失败：%@=%@已经存在",[Obj primaryKey],[obj valueForKeyPath:[Obj primaryKey]]);
    }
}

/* 删 */
- (void)deleteWithRLMObjectClass:(Class)Obj primaryKey:(NSString *)primaryKey{
    RLMObject *obj = [self selectWithRLMObjectClass:Obj primaryKey:primaryKey].firstObject;
    if (obj) {
        [self deleteRLMObject:obj];
    }
}

- (void)deleteRLMObject:(RLMObject *)obj{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:obj];
    [realm commitWriteTransaction];
}

- (void)deleteRLMObjects:(NSArray<RLMObject *> *)objs{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:objs];
    [realm commitWriteTransaction];
}

- (void)deleteAllObjects{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

/* 改 */
- (void)updateRLMObject:(RLMObject *)obj{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [realm addOrUpdateObject: obj];
        }];
    });
}
- (void)updateInRLMObject:(Class)Obj value:(NSDictionary *)value{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            [Obj createOrUpdateInRealm:realm withValue:value];
        }];
    });
}
- (void)updateRLMObjects:(NSArray<RLMObject *> *)objs{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addOrUpdateObjects:objs];
    [realm commitWriteTransaction];
}


/* 查 */
- (RLMResults *)selectAllObjectsInRLMObjectClass:(Class) Obj{
    return [Obj allObjects];
}

- (RLMResults *)selectWithRLMObjectClass:(Class) Obj primaryKey:(NSString *)primaryKey{
    return [self selectWithRLMObjectClass:Obj parameter:@{[Obj primaryKey]:primaryKey}];
}

- (RLMResults *)selectWithRLMObjectClass:(Class) Obj parameter:(NSDictionary *) parameter{
   return [Obj objectsWhere:[self whereByParsingParameter:parameter]];
}

- (RLMResults *)selectWithRLMObjectClass:(Class) Obj where:(NSString *) where{
    return [Obj objectsWhere:where];
}

- (RLMResults *)selectWithRLMObjectClass:(Class) Obj predicate:(NSPredicate *) predicate{
    return [Obj objectsWithPredicate:predicate];
}

- (RLMResults *)sortWithRLMResults:(RLMResults *) results sortedProperty:(NSString *)property ascending:(BOOL)ascending{
    return [results sortedResultsUsingKeyPath:property ascending:ascending];
}

#pragma mark private
- (Class)rlmClassFromRLMObject:(RLMObject *) obj{
    NSString *className = [NSString stringWithCString:object_getClassName(obj) encoding:NSUTF8StringEncoding];
    return NSClassFromString(className);
}
- (NSString *)whereByParsingParameter:(NSDictionary *) parameter{
    NSString *where = @"";
    for (NSString *key in parameter.allKeys) {
        if (where.length == 0) {
            where = [where stringByAppendingFormat:@"%@ = '%@'",key,[parameter objectForKey:key]];
        }else{
           where = [where stringByAppendingFormat:@"AND %@ = '%@'",key,[parameter objectForKey:key]];
        }
    }
    return where;
}
- (RLMRealmConfiguration *)realmConfig{
    return [RLMRealmConfiguration defaultConfiguration];
}
- (BOOL)selectIsExistWithRLMObjectClass:(Class) Obj primaryKey:(NSString *)primaryKey{
    if (!primaryKey || primaryKey.length == 0) return YES;
    RLMResults *results = [self selectWithRLMObjectClass:Obj primaryKey:primaryKey];
    if (!results.isInvalidated &&
        results.count > 0) {
        return YES;
    }
    return NO;
}
@end
