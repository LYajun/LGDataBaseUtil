//
//  User.h
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//
//  注意，RLMObject 官方建议不要加上 Objective-C的property attributes(如nonatomic, atomic, strong, copy, weak 等等）假如设置了，这些attributes会一直生效直到RLMObject被写入realm数据库。

#import <Realm/Realm.h>
#import "Car.h"
#import "Dog.h"

@interface User : RLMObject
/** 用户ID */
@property NSString *uid;
/** 用户名 */
@property NSString *uname;
/** 拥有的狗 */
@property Dog *dog;
/** 拥有的车子 */
@property RLMArray<Car> *cars;
@end
RLM_ARRAY_TYPE(User) // 定义RLMArray

