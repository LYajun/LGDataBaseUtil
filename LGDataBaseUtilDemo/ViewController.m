//
//  ViewController.m
//  LGDataBaseUtilDemo
//
//  Created by 刘亚军 on 2018/4/10.
//  Copyright © 2018年 刘亚军. All rights reserved.
//

#import "ViewController.h"
#import "LGDataBaseUtil.h"
#import "User.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIDField;
@property (weak, nonatomic) IBOutlet UITextField *unameField;
@property (weak, nonatomic) IBOutlet UITextField *carNameField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LG_DBUtil createDataBaseWithName:@"LGDataBase.realm"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"数据库路径: %@", [LG_DBUtil dbFilePath]);
}
- (NSDictionary *)userInfo{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *arr = [NSMutableArray array];
    if (self.userIDField.text.length > 0) {
        [dic setValue:self.userIDField.text forKey:@"uid"];
    }
    if (self.unameField.text.length > 0) {
         [dic setValue:self.unameField.text forKey:@"uname"];
    }
    [dic setValue:@{@"gname":@"小黄",@"guserName":self.unameField.text} forKey:@"dog"];
    if (self.carNameField.text.length > 0) {
        if ([self.carNameField.text containsString:@","]) {
            NSArray *cars = [self.carNameField.text componentsSeparatedByString:@","];
            for (NSString *cName in cars) {
                NSMutableDictionary *d = [NSMutableDictionary dictionary];
                [d setValue:cName forKey:@"cname"];
                [d setValue:self.unameField.text forKey:@"cuserName"];
                [arr addObject:d];
            }
        }else{
            NSMutableDictionary *d = [NSMutableDictionary dictionary];
            [d setValue:self.carNameField.text forKey:@"cname"];
            [d setValue:self.unameField.text forKey:@"cuserName"];
            [arr addObject:d];
        }
    }
    [dic setValue:arr forKey:@"cars"];
    return dic;
}
- (void)clearData{
    self.userIDField.text = @"";
    self.unameField.text = @"";
    self.carNameField.text = @"";
}
- (IBAction)add:(UIButton *)sender {
    [self.view endEditing:YES];
    User *user = [User lg_objectWithDictionary:self.userInfo];
    [LG_DBUtil addRLMObject: user];
    self.resultTextView.text = @"添加完成";
    [self clearData];
}
- (IBAction)delete:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.userIDField.text.length > 0) {
        [LG_DBUtil deleteWithRLMObjectClass:User.class primaryKey:self.userIDField.text];
        self.resultTextView.text = @"删除完成";
    }else{
        self.resultTextView.text = @"用户ID不能为空!";
    }
    [self clearData];
}
- (IBAction)update:(UIButton *)sender {
    [self.view endEditing:YES];
    [LG_DBUtil updateInRLMObject:User.class value:self.userInfo];
    self.resultTextView.text = @"更新完成";
    [self clearData];
}
- (IBAction)select:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.userIDField.text.length > 0) {
       RLMResults *results = [LG_DBUtil selectWithRLMObjectClass:User.class primaryKey:self.userIDField.text];
        User *user = results.firstObject;
        self.resultTextView.text = [user lg_JSONString];
    }else{
        self.resultTextView.text = @"用户ID不能为空!";
    }
    [self clearData];
}
- (IBAction)selectAll:(UIButton *)sender {
    [self.view endEditing:YES];
    RLMResults *results = [LG_DBUtil selectAllObjectsInRLMObjectClass:User.class];
    NSMutableArray *arr = [NSMutableArray array];
    for (RLMObject *obj in results) {
        [arr addObject:[obj lg_JSONObject]];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    self.resultTextView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self clearData];
}


@end
