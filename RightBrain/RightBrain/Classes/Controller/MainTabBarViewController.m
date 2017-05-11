//
//  MainTabBarViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "HomeTableViewController.h"
#import "ProfileTableViewController.h"
#import "MainNavViewController.h"
#import "TextEditorViewController.h"
#import "TypeView.h"
#import "SoundEditorViewController.h"

@interface MainTabBarViewController ()

/** 发布信息按钮 */
@property (nonatomic, strong) UIButton *componeButton;


@end

@implementation MainTabBarViewController

#pragma mark - 懒加载发布信息按钮
- (UIButton *)componeButton
{
    if (!_componeButton) {
        _componeButton =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
        
    }
    return _componeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置界面
    [self setupUI];
}

#pragma mark - 设置界面
- (void)setupUI
{
    [self setupChilds];
    [self setupComponeButton];
}

/** 设置首页和设置界面 */
- (void)setupChilds
{
    // 首页
    MainNavViewController *home = [[MainNavViewController alloc] initWithRootViewController:[HomeTableViewController new]];
    home.title = @"列表";
    // 图片
    home.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    home.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [home.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: golbal_color(0 , 0, 0)} forState: UIControlStateHighlighted];
    
    // 个人设置
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ProfileTableViewController" bundle:nil];
    ProfileTableViewController *profileVC = [storyboard instantiateViewControllerWithIdentifier:@"profileID"];
    MainNavViewController *profile = [[MainNavViewController alloc] initWithRootViewController: profileVC];
    profile.title = @"设置";
    // 图片
    profile.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    profile.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [profile.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: golbal_color(0, 0, 0)} forState: UIControlStateHighlighted];
    
    // 加入main视图
    self.viewControllers = @[home, profile];
    // 设置tabbar的背景图片
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];


}

/** 设置写日志按钮 */
- (void)setupComponeButton
{
    // 设置按钮的前景和背景图片
    UIImage *imgNormal = [UIImage imageNamed:@"tabbar_compose_icon_add"];
    UIImage *imgHightlightred = [UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"];
    
    UIImage *imgBG = [UIImage imageNamed:@"2btn_background"];
    
    [self.componeButton setImage:imgNormal forState:UIControlStateNormal];
    
    [self.componeButton setImage:imgHightlightred forState:UIControlStateHighlighted];
    
    [self.componeButton setBackgroundImage:imgBG forState:UIControlStateNormal];
    
    [self.tabBar addSubview:self.componeButton];
    
    // 设置位置和大小
    CGFloat tabbarWidth = self.tabBar.width;
    CGFloat btnW = tabbarWidth / 5;
    
    // 移动位置
    self.componeButton.frame = CGRectInset(self.tabBar.bounds, 2 * btnW, -5);
    
    // 点击方法
    [self.componeButton addTarget:self action:@selector(componeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark - 发布按钮点击
- (void)componeButtonClick:(UIButton *)btn
{

    TypeView *typev = [TypeView typeView];
    
    [typev show:^void(int index) {
        switch (index) {
            case 1:
                // 文字编辑
                [self popTxtEditorView];
                break;
                
            default:
                // 录音编辑
                [self popSoundEditorView];
                break;
        }
    }];
}

#pragma mark - 弹出文字编辑界面
- (void)popTxtEditorView
{
    // 弹出文本编辑视图
    TextEditorViewController *texteditor = [TextEditorViewController new];
    MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:texteditor];
    texteditor.isEditored = YES;
    
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 弹出录音编辑界面
- (void)popSoundEditorView
{
    // 弹出编辑视图
    SoundEditorViewController *soundEditor = [SoundEditorViewController new];
    MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:soundEditor];
    soundEditor.isEditored = YES;
    
    [self presentViewController:nav animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
