//
//  PWDTableViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/5.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "PWDTableViewController.h"
#import "PWDViewController.h"

@interface PWDTableViewController ()
/** switch开关 */
@property (weak, nonatomic) IBOutlet UISwitch *openPwd;
/** 静态的cell */
@property (weak, nonatomic) IBOutlet UITableViewCell *pwdStaticCell;


@end

@implementation PWDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 根据开关的状态来设置cell的隐藏
    [self setupUI];

}

#pragma mark - 页面显示和隐藏的时候注销通知
- (void)viewWillAppear:(BOOL)animated
{
    // 这册密码修改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPasswordSetSuccess) name:userPasswordSetSuccess object:nil];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 设置界面
- (void)setupUI
{
    // 设置密码开关状态
    NSString *isOpen = [[NSUserDefaults standardUserDefaults] valueForKey:userPasswordIsOpen];
    
    [self.openPwd setOn:[isOpen isEqualToString:@"YES"]];
    // 设置密码cell的隐藏
    self.pwdStaticCell.hidden = !self.openPwd.isOn;
    
}

#pragma mark - 静态方法
+ (instancetype)pwdTableView
{

    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"ProfileTableViewController" bundle:nil];
    
    return  [stroyBoard instantiateViewControllerWithIdentifier:@"pwdMainID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 开启密码的开发点击
- (IBAction)switchOpenClick:(UISwitch *)sender {
    
    // 设置密码cell的隐藏
    self.pwdStaticCell.hidden = !self.openPwd.isOn;
    
    // 判断状态 如果是开启那么要验证密码
    if (![sender isOn]){
        
        // 设置偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:userPasswordIsOpen];
        
    }else {
        // 设置偏好设置
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:userPasswordIsOpen];
    }
    
}

// 密码cell 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 载入密码设置界面
    PWDViewController *pwdVC = [PWDViewController pwdVC];
    pwdVC.isEditorPWD = YES;
    [self.navigationController pushViewController: pwdVC animated:YES];
}

#pragma mark - 键盘密码修改通知
- (void)userPasswordSetSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
