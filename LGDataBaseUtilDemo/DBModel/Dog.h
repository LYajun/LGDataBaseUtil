//
//  Dog.h
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Realm/Realm.h>

@interface Dog : RLMObject
/** 狗名 */
@property NSString *gname;
/** 狗拥有者 */
@property NSString *guserName;
@end
RLM_ARRAY_TYPE(Dog) // 定义RLMArray
