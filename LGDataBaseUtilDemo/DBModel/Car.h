//
//  Car.h
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Realm/Realm.h>

@class User;
@interface Car : RLMObject
/** 车名 */
@property NSString *cname;
/** 车拥有者 */
@property NSString *cuserName;
@end
RLM_ARRAY_TYPE(Car) // 定义RLMArray

