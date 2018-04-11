//
//  User.m
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "User.h"
#import "Car.h"

@implementation User
// 主键
+ (NSString *)primaryKey {
    return @"uid";
}
//设置属性默认值
//+ (NSDictionary *)defaultPropertyValues{
//    return @{@"carName":@"测试" };
//}

//设置忽略属性,即不存到realm数据库中
//+ (NSArray *)ignoredProperties {
//    return @[@"ID"];
//}

//一般来说,属性为nil的话realm会抛出异常,但是如果实现了这个方法的话,就只有name为nil会抛出异常,也就是说现在cover属性可以为空了
//+ (NSArray *)requiredProperties {
//    return @[@"name"];
//}

//设置索引,可以加快检索的速度
+ (NSArray *)indexedProperties {
    return @[@"uid"];
}

+ (NSDictionary *)lg_objectClassInArray{
    return @{@"cars":Car.class};
}
@end
