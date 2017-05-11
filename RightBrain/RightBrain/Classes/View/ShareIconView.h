//
//  ShareIconView.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/7.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetModel.h"

@interface ShareIconView : UIView

/** 数据源 */
@property (nonatomic, strong) NSArray<ActionSheetModel *> *listData;


/** 点击回调block */
@property (nonatomic, copy) void (^actionSheetClick)(NSInteger clickIndex);


/** 展现方法 */
-(void)showInView:(UIViewController *)vc;

/** 隐藏方法 */
-(void)dismis;

@end
