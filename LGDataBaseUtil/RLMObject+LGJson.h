//
//  RLMObject+LGJson.h
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import <Realm/Realm.h>
@protocol RLMObjectDelegate <NSObject>
@optional
// 提供一个协议，只要准备这个协议的类，都能把数组中的字典转模型
+ (NSDictionary *)lg_objectClassInArray;
@end
@interface RLMObject (LGJson)
+ (instancetype)lg_objectWithDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)lg_JSONObject;
- (NSString *)lg_JSONString;
@end
