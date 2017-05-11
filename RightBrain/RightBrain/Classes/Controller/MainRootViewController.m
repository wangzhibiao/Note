//
//  MainRootViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/5.
//  Copyright © 2017年 王小帅. All rights reserved.
//
// 当窗口加载控制器的时候 这个类用来判断是否开启了密码验证

#import "MainRootViewController.h"
#import "MainTabBarViewController.h"
#import "PWDViewController.h"



@interface MainRootViewController ()

@property (nonatomic, strong) MainTabBarViewController *mainVC;
@property (nonatomic, strong) PWDViewController *pwdVC;



@end

@implementation MainRootViewController

#pragma mark - 懒加载
- (MainTabBarViewController *)mainVC
{
    if (!_mainVC){
        _mainVC = [MainTabBarViewController new];
    }
    return _mainVC;
}

- (PWDViewController *)pwdVC
{
    if (!_pwdVC) {
        _pwdVC = [PWDViewController pwdVC];
    }
    return _pwdVC;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 判断是否开启了密码验证
    NSString *isOpen = [[NSUserDefaults standardUserDefaults] valueForKey:userPasswordIsOpen];
    
    if ([isOpen isEqualToString:@"YES"]){
        [self.view addSubview:self.pwdVC.view];
        [self addChildViewController:self.pwdVC];

    }else {
    
        [self.view addSubview:self.mainVC.view];
        [self addChildViewController:self.mainVC];
    }
    
    // 监听验证密码通知
    // 注册密码验证通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userPasswordTestSuccess) name:userPasswordTestSuccess object:nil];
}


- (void)userPasswordTestSuccess
{
    // 移除密码控制器
    [self.pwdVC removeFromParentViewController];
    
    // 加载主页控制器
    [self.view addSubview:self.mainVC.view];
    [self addChildViewController:self.mainVC];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
