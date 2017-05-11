//
//  PWDViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/5.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "PWDViewController.h"
//#import "LocalPWDTool.h"

@interface PWDViewController ()<UITextFieldDelegate>
/** 密码框 */
@property (weak, nonatomic) IBOutlet UITextField *pwdTextInput;
/** 新密码文本框 */
@property (weak, nonatomic) IBOutlet UITextField *pwdNewTextInput;


@end

@implementation PWDViewController


#pragma mark - 类方法获取实例
+ (instancetype)pwdVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ProfileTableViewController" bundle:nil];
    PWDViewController *pwd = [sb instantiateViewControllerWithIdentifier:@"passwordVC"];
    return pwd;
}

/** 页面加载 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 是否为修改密码界面
    self.pwdNewTextInput.hidden = !self.isEditorPWD;

    // 设置键盘的返回按钮类型
    self.pwdTextInput.returnKeyType = self.isEditorPWD ? UIReturnKeyNext : UIReturnKeyDone;
    // 调出键盘
    [self.pwdTextInput becomeFirstResponder];
    
}

#pragma mark - 键盘确认按钮点击
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    // 非空判断
    if ([self.pwdTextInput.text isEqualToString:@""]){
        
        [SVProgressHUD showErrorWithStatus:@"请输入原始密码"];
        return NO;
    }
    
    // 跳过
    if (textField.returnKeyType == UIReturnKeyNext){
        [self.pwdNewTextInput becomeFirstResponder];
    }
    
    // 确定
    if (textField.returnKeyType == UIReturnKeyDone){
        
        // 获取密码比较
        NSString *pwd = [LocalPWDTool getPwd];
        if (pwd){// 本地已有密码
            
            if ([pwd isEqualToString:self.pwdTextInput.text]){
                
                // 判断是不是修改密码
                if (self.isEditorPWD){
                    
                    if ([self.pwdNewTextInput.text isEqualToString:@""]){
                        [SVProgressHUD showErrorWithStatus:@"请输入新密码"];
                        return NO;
                    }
                    
                    // 存储新密码
                    [LocalPWDTool savePwd:self.pwdNewTextInput.text];
                    [SVProgressHUD showSuccessWithStatus:@"密码修改完成"];
                    // 发送保存密码通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:userPasswordSetSuccess object:nil];
                    // 取消键盘
                    [self.pwdTextInput endEditing:YES];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                    return YES;
                }
                
                // 发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:userPasswordTestSuccess object:nil];
                // 取消键盘
                [self.pwdTextInput endEditing:YES];
                
            }else {
                // 验证密码失败
                [SVProgressHUD showSuccessWithStatus:@"密码错误"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
        }else {
            // 本地没有密码 存储
            [LocalPWDTool savePwd:self.pwdTextInput.text];
            [SVProgressHUD showSuccessWithStatus:@"密码设置完成"];
            // 发送保存密码通知
            [[NSNotificationCenter defaultCenter] postNotificationName:userPasswordSetSuccess object:nil];
            // 默认打开验证
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:userPasswordIsOpen];
            // 取消键盘
            [self.pwdTextInput endEditing:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }
    
    return YES;
}


@end
