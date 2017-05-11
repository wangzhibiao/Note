//
//  ProfileTableViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "PWDTableViewController.h"
#import "PWDViewController.h"

@interface ProfileTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *isOpenLabel;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // title
    UILabel *title = [UILabel new];
    title.text = @"关于软件";
    title.textColor = golbal_color(0, 0, 0);
    title.font = [UIFont systemFontOfSize:17 weight:1];
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    // 设置返回按钮样式
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}


#pragma mark - 页面显示和隐藏的时候注销通知
- (void)viewWillAppear:(BOOL)animated
{
    // 设置密码开关状态
    NSString *isOpen = [[NSUserDefaults standardUserDefaults] valueForKey:userPasswordIsOpen];
    
    self.isOpenLabel.text = [isOpen isEqualToString:@"YES"] ? @"打开" : @"关闭";
    
    // 这册密码修改通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPasswordSetSuccess) name:userPasswordSetSuccess object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 密码验证和设置通知方法
- (void)userPasswordSetSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 密码cell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 判断是否已经设置过密码 没有要先设置
    NSString *pwd = [LocalPWDTool getPwd];
    if (pwd){
    
        PWDTableViewController *pwdVC = [PWDTableViewController pwdTableView];
        
        [self.navigationController pushViewController:pwdVC animated:YES];
        
    }else{
        
        [self.navigationController pushViewController:[PWDViewController pwdVC] animated:YES];
        
    }
}

/** 注销通知 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
