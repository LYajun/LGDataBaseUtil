//
//  RLMObject+LGJson.m
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "RLMObject+LGJson.h"
#import <objc/message.h>
#import <Realm/Realm.h>

@implementation RLMObject (LGJson)
+ (instancetype)lg_objectWithDictionary:(NSDictionary *)aDictionary{
    id objc = [[self alloc] init];
    unsigned int count;
    // 获取类中的所有成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
     for (int i = 0; i < count; i++) {
         // 根据角标，从数组取出对应的成员属性
         Ivar ivar = ivarList[i];
         // 获取成员属性名
         NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
         // 处理成员属性名->字典中的key
         // 从第一个角标开始截取
         NSString *key = [name substringFromIndex:1];
         // 根据成员属性名去字典中查找对应的value
         id value = aDictionary[key];
         // 二级转换:如果字典中还有字典，也需要把对应的字典转换成模型
         // 判断下value是否是字典
         if ([value isKindOfClass:[NSDictionary class]]) {
             // 字典转模型
             // 获取模型的类对象，调用objectWithDictionary
             // 模型的类名已知，就是成员属性的类型
             // 获取成员属性类型
             NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
             // 生成的是这种@"@\"User\"" 类型 -> @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
             // 裁剪类型字符串
             NSRange range = [type rangeOfString:@"\""];
             type = [type substringFromIndex:range.location + range.length];
             range = [type rangeOfString:@"\""];
             // 裁剪到哪个角标，不包括当前角标
             type = [type substringToIndex:range.location];
             // 根据字符串类名生成类对象
             Class modelClass = NSClassFromString(type);
             if (modelClass) { // 有对应的模型才需要转
                 // 把字典转模型
                 value = [modelClass lg_objectWithDictionary:value];
             }
         }
         
         // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
         // 判断值是否是数组
         if ([value isKindOfClass:[NSArray class]]) {
             // 判断对应类有没有实现字典数组转模型数组的协议
             if ([self respondsToSelector:@selector(lg_objectClassInArray)]) {
                 // 转换成id类型，就能调用任何对象的方法
                 id idSelf = self;
                 // 获取数组中字典对应的模型
                  Class classModel =  [idSelf lg_objectClassInArray][key];
                 RLMArray *arr = [objc valueForKeyPath:key];
                 // 遍历字典数组，生成模型数组
                 for (NSDictionary *dict in value) {
                     // 字典转模型
                     id model =  [classModel lg_objectWithDictionary:dict];
                     [arr addObject:model];
                 }
                 value = arr;
             }
         }
         
         if (value) { // 有值，才需要给模型的属性赋值
             // 利用KVC给模型中的属性赋值
             [objc setValue:value forKey:key];
         }
     }
    
    
    return objc;
}
- (NSDictionary *)lg_JSONObject{
    Class Obj = NSClassFromString([[self class] className]);
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(Obj, &count);
    NSMutableDictionary *jsonModel = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *key = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKeyPath:key];
        if (!value || value == [NSNull null]) continue;
        if ([value isKindOfClass:[RLMObject class]]) {
            value = [value lg_JSONObject];
        }
        if ([value isKindOfClass:[RLMArray class]]) {
            NSMutableArray *valueArr = [NSMutableArray array];
            for (RLMObject *obj in value) {
                [valueArr addObject:[obj lg_JSONObject]];
            }
            value = valueArr;
        }
        [jsonModel setValue:value forKey:key];
    }
    return jsonModel;
}
- (NSString *)lg_JSONString{
    NSDictionary *json = [self lg_JSONObject];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
