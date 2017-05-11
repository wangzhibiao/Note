//
//  ShareIconView.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/7.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "ShareIconView.h"
#import "ActionSheetModelView.h"

@interface ShareIconView()<UIGestureRecognizerDelegate>

// 背景view
@property (nonatomic, strong) UIView *bgView;
// sheet的容器view
@property (nonatomic, strong) UIView *sheetsView;

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) UITapGestureRecognizer *tapGest;



@end

@implementation ShareIconView


#pragma mark - 懒加载
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgView;
}

- (UIView *)sheetsView
{
    if (!_sheetsView) {
        _sheetsView = [UIView new];
    }
    
    return _sheetsView;
}

- (UITapGestureRecognizer *)tapGest
{
    if (!_tapGest) {
        _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapClick:)];
    }
    return _tapGest;
}




#pragma mark - 重写setter方法
- (void)setListData:(NSArray<ActionSheetModel *> *)listData
{
    _listData = listData;
    
    // 根据数据设置表格容器
    if (listData){
        [self addSubview:self.bgView];
        [self addSubview:self.sheetsView];
        [self setupSheetsViewWidthList:listData];
    }
}

/**  根据数据设置表格容器 */
- (void)setupSheetsViewWidthList:(NSArray<ActionSheetModel *> *)listdata
{
    CGFloat sheetH = 64;
    NSUInteger count = listdata.count;
    
    self.sheetsView.height = sheetH * count;
    
    [listdata enumerateObjectsUsingBlock:^(ActionSheetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 显示内容
        ActionSheetModelView *v = [ActionSheetModelView actionWithModel:obj];
        v.frame = CGRectMake(0, (idx * sheetH), SCREEN_WIDTH, sheetH);
        // 遮罩按钮接收点击
        UIButton *coverBtn = [[UIButton alloc] initWithFrame:v.frame];
        coverBtn.tag = idx;
        [coverBtn addTarget:self action:@selector(coverBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [coverBtn setTitle:@"888" forState:UIControlStateNormal];
        // 按顺序添加
        [self.sheetsView addSubview:v];
        [self.sheetsView addSubview:coverBtn];
    }];
}

// 点击屌用block
- (void)coverBtnClick:(UIButton *)btn
{
    if (self.actionSheetClick){
        _actionSheetClick(btn.tag);
        [self dismis];
    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isKindOfClass:[self class]]) {
//        return YES;
//    }
//    return YES;
//}


// 背景点击
- (void)bgTapClick:(UITapGestureRecognizer *)gest
{
    
    if ([gest.self.view isKindOfClass:[UIButton class]]){
        [self dismis];
    }
}



/** 展现方法 */
-(void)showInView:(UIViewController *)vc
{
    if (!self.isShow) {

        [vc.view addSubview:self];
        self.tapGest.delegate = self;
        
        [self.bgView setUserInteractionEnabled: YES];
        [self.sheetsView setUserInteractionEnabled:YES];
        self.sheetsView.backgroundColor = [UIColor orangeColor];
        
        self.sheetsView.y = SCREEN_HEIGHT;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.sheetsView.y = SCREEN_HEIGHT - self.sheetsView.height;

        } completion:^(BOOL finished) {
            
            [self.bgView addGestureRecognizer:self.tapGest];
            self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            self.isShow = YES;
        }];
    }
}

/** 隐藏方法 */
-(void)dismis;
{
    if (self.isShow) {
     
        [UIView animateWithDuration:0.25 animations:^{
            
            self.sheetsView.y = SCREEN_HEIGHT;

        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
            self.isShow = NO;
        }];
    }
}

@end
