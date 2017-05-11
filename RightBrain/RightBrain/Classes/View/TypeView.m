//
//  TypeView.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/9.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "TypeView.h"
@interface TypeView()

@property (nonatomic, strong) UIButton *txtButton;
@property (nonatomic, strong) UIButton *soundButton;



@end


@implementation TypeView




#pragma mark - 实力方法
+ (instancetype)typeView
{
    UINib *nib = [UINib nibWithNibName:@"TypeView" bundle:nil];
    
    TypeView *tv = [nib instantiateWithOwner:nil options:nil][0];
    // 设置属性
    tv.frame = [UIScreen mainScreen].bounds;
    // 设置按钮
    [tv setupChilds];
    
    return tv;
}

#pragma mark - 取消按钮点击
- (IBAction)cancelButtonClick:(id)sender {
    
    [self hidden];
}


#pragma mark - 设置按钮方法
- (void)setupChilds
{
    // 文字和图片按钮
    self.txtButton = [self createButtonWithImage:@"wenzi" title:@"文字"];
    [self.txtButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.txtButton.center =  CGPointMake(self.center.x, self.center.y+35);
    //CGRectMake(, self., 200, 60);
    self.txtButton.tag = 1;
    [self addSubview:self.txtButton];
    
    // 声音按钮
    self.soundButton = [self createButtonWithImage:@"luyin" title:@"声音"];
     [self.soundButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.soundButton.center = CGPointMake(self.center.x, self.center.y-35);
    //CGRectMake(self.center.x, self.center.y-35, 200, 60);
    self.soundButton.tag = 2;
    [self addSubview:self.soundButton];
}

// 创建按钮
- (UIButton *)createButtonWithImage:(NSString *)imageName title:(NSString *)title
{
    UIButton *button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:@"typebg"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 50)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    button.width = SCREEN_WIDTH-20;
    button.height = 60;
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@n",imageName]];
    UIImage *imageH = [UIImage imageNamed:[NSString stringWithFormat:@"%@hi",imageName]];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:imageH forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:golbal_color(128, 19, 18) forState:UIControlStateHighlighted];
    

    return button;
}

#pragma mark - 按钮点击
- (void)typeButtonClick:(UIButton *)button
{
    [self hiddenTypeButtonAnimated];
    
    if (self.myTypeButtonClickBlock){
        self.myTypeButtonClickBlock((int)button.tag);
    }
}



#pragma mark - 动画相关方法

#pragma mark - 展示
- (void)show:(typeButtonClickBlock)block
{
    // 先占有这个block 在点击按钮的时候屌用
    self.myTypeButtonClickBlock = block;
    
    // 根是图加载
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [root.view addSubview:self];
    // 加入动画
    [self showBGViewAnimated];
    [self showTypeButtonAnimated];
}

#pragma mark - 隐藏
- (void)hidden
{
    [self hiddenTypeButtonAnimated];
}

#pragma mark -  设置背景的动画
- (void)showBGViewAnimated
{
    // 定义基础动画 改变头精度
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.fromValue = @0;
    anim.toValue = @1;
    anim.duration = 0.5;
    
    [self pop_addAnimation:anim forKey:nil];
}

- (void)hideBGViewAnimated
{
    // 定义基础动画 改变头精度
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.fromValue = @1;
    anim.toValue = @0;
    anim.duration = 0.5;
    
    [self pop_addAnimation:anim forKey:nil];
    
    anim.completionBlock = ^(POPAnimation *anim,BOOL flag){
        
        [self removeFromSuperview];
    };

}


#pragma mark - 设置按钮的动画
- (void)showTypeButtonAnimated
{
    // 文字动画
    POPSpringAnimation *txtAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    txtAnim.fromValue = @(self.txtButton.center.x - 400);
    txtAnim.toValue = @(self.txtButton.center.x);
    
    txtAnim.springBounciness = 8;
    txtAnim.springSpeed = 8;
    
    
    [self.txtButton pop_addAnimation:txtAnim forKey:nil];
    
    // 声音动画
    POPSpringAnimation *soundAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    soundAnim.fromValue = @(self.txtButton.center.x + 400);
    soundAnim.toValue = @(self.txtButton.center.x);
    
    soundAnim.springBounciness = 8;
    soundAnim.springSpeed = 8;
    
    [self.soundButton pop_addAnimation:soundAnim forKey:nil];
}


- (void)hiddenTypeButtonAnimated
{
    // 文字动画
    POPSpringAnimation *txtAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    txtAnim.fromValue = @(self.txtButton.center.x);
    txtAnim.toValue = @(self.txtButton.center.x - 400);
    
    txtAnim.springBounciness = 8;
    txtAnim.springSpeed = 8;
    
    [self.txtButton pop_addAnimation:txtAnim forKey:nil];
    
    
    // 声音动画
    POPSpringAnimation *soundAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    soundAnim.fromValue = @(self.txtButton.center.x);
    soundAnim.toValue = @(self.txtButton.center.x + 400);
    
    soundAnim.springBounciness = 8;
    soundAnim.springSpeed = 8;
    
    [self.soundButton pop_addAnimation:soundAnim forKey:nil];
    
    [self hideBGViewAnimated];
}





@end
