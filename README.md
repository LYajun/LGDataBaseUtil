# LGDataBaseUtil
数据库管理(基于Realm)
<div align="left">
<img src="https://github.com/LYajun/LGDataBaseUtil/blob/master/Assets/snip1.png" width ="375" height ="667" >
<img src="https://github.com/LYajun/LGDataBaseUtil/blob/master/Assets/snip2.png" width ="375" height ="667" >
 </div>
 
## 使用方式
 
1、集成:

```
pod 'LGDataBaseUtil'
```
 
2、建表

Realm数据模型是基于标准 Objective‑C 类来进行定义的，使用属性来完成模型的具体定义。

我们只需要继承 RLMObject或者一个已经存在的模型类，您就可以创建一个新的 Realm 数据模型对象。对应在数据库里面就是一张表。

<img src="https://github.com/LYajun/LGDataBaseUtil/blob/master/Assets/snip4.png" width ="378" height ="309" >

> 注意: 
> 
> RLMObject 官方建议不要加上 Objective-C的property attributes(如nonatomic, atomic, strong, copy, weak 等等）假如设置了，这些attributes会一直生效直到RLMObject被写入realm数据库。
> 
> RLM_ARRAY_TYPE宏创建了一个协议，从而允许 RLMArray语法的使用。

给RLMObject设置主键primaryKey，默认值defaultPropertyValues，忽略的属性ignoredProperties，必要属性requiredProperties，索引indexedProperties。比较有用的是主键和索引

<img src="https://github.com/LYajun/LGDataBaseUtil/blob/master/Assets/snip3.png" width ="956" height ="551" >

3、增


```objective-c
/* 增 */
- (void)addRLMObject:(RLMObject *)obj;
```
4、删

```objective-c
/** 删 单条记录*/
- (void)deleteWithRLMObjectClass:(Class) Obj primaryKey:(NSString *)primaryKey;
- (void)deleteRLMObject:(RLMObject *)obj;
/** 删 多条记录*/
- (void)deleteRLMObjects:(NSArray<RLMObject *> *)objs;
/** 删 所有记录*/
- (void)deleteAllObjects;
```

5、改

```objective-c
/** 改 针对单个数据进行的修改或新增
 方法的前提是有主键,方法会先去主键里面找有没有字典里面传入的主键的记录，如果有就更新该条数据
 注意：所有的值都必须有，如果有哪几个值是null，那么就会覆盖原来已经有的值，这样就会出现数据丢失的问题*/
- (void)updateRLMObject:(RLMObject *)obj;
/** 改 针对单个数据进行的修改或新增
 方法的前提是有主键，方法会先去主键里面找有没有字典里面传入的主键的记录，如果有，就只更新字典里面的子集。如果没有，就新建一条记录*/
- (void)updateInRLMObject:(Class)Obj value:(NSDictionary *)value;
/** 改 针对一组数据的修改或新增*/
- (void)updateRLMObjects:(NSArray<RLMObject *> *)objs;
```

6、查

```objective-c
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
```