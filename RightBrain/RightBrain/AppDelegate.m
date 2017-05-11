//
//  AppDelegate.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/1.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "AppDelegate.h"
#import "MainRootViewController.h"
#import "WXApi.h"
#import "SoundEditorViewController.h"
#import "TextEditorViewController.h"
#import "MainNavViewController.h"


@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 注册微信
    [WXApi registerApp:kAppID];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [MainRootViewController new];
    [_window makeKeyAndVisible];
    
    
    // 创建3dtouch的首页呼出菜单
    [self createHomeItems];
    
    return YES;
}


#pragma mark - 创建3dtouch首页呼出菜单
- (void)createHomeItems
{
    // 写文字
    UIApplicationShortcutIcon *textIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"wenzihi"];
    
    UIApplicationShortcutItem *textItem = [[UIApplicationShortcutItem alloc] initWithType:@"doText" localizedTitle:@"文字" localizedSubtitle:nil icon:textIcon userInfo:nil];
    
    // 发语音
    UIApplicationShortcutIcon *audioIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"luyinhi"];
    
    UIApplicationShortcutItem *audioItem = [[UIApplicationShortcutItem alloc] initWithType:@"doAudio" localizedTitle:@"语音" localizedSubtitle:nil icon:audioIcon userInfo:nil];
    
    // 加入菜单
    [UIApplication sharedApplication].shortcutItems = @[textItem, audioItem];
}

#pragma mark - 首页快捷方式点击
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    NSLog(@"点击了 %@.", shortcutItem.localizedTitle);
    
    if ([shortcutItem.type isEqualToString:@"doText"]) {
        [self loadTextEditorView];
    }
    
    if ([shortcutItem.type isEqualToString:@"doAudio"]) {
        [self loadAudioEditorView];
    }
}

#pragma mark - 加载文字和录音的界面
- (void)loadTextEditorView
{
    MainRootViewController *main = [MainRootViewController new];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = main;
    [_window makeKeyAndVisible];

    // 弹出文本编辑视图
    TextEditorViewController *texteditor = [TextEditorViewController new];
    MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:texteditor];
    texteditor.isEditored = YES;
    
    [main presentViewController:nav animated:YES completion:nil];

}

- (void)loadAudioEditorView
{
    MainRootViewController *main = [MainRootViewController new];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = main;
    [_window makeKeyAndVisible];
    
    // 弹出文本编辑视图
    SoundEditorViewController *soundEditor = [SoundEditorViewController new];
    MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:soundEditor];
    soundEditor.isEditored = YES;
    
    [main presentViewController:nav animated:YES completion:nil];
}



#pragma mark - 重写微信需要的屌用的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)onReq:(BaseReq *)req
{
    NSLog(@"********req**********");
}
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"********resp**********");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
    // 判断是否开启了密码验证
    NSString *isOpen = [[NSUserDefaults standardUserDefaults] valueForKey:userPasswordIsOpen];
    
    if ([isOpen isEqualToString:@"YES"]){
        
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.rootViewController = nil;
        _window.rootViewController = [MainRootViewController new];
        [_window makeKeyAndVisible];
        
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
