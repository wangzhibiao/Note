//
//  PWDViewController.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/5.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWDViewController : UIViewController

// 是否为修改密码
@property (nonatomic, assign) BOOL isEditorPWD;


// 类方法获取实例
+ (instancetype)pwdVC;

@end
