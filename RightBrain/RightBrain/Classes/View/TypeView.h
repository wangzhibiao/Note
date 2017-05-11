//
//  TypeView.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/9.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义按钮顶级的block
typedef void(^typeButtonClickBlock)(int index);

@interface TypeView : UIView

@property (nonatomic, copy) typeButtonClickBlock myTypeButtonClickBlock;

+ (instancetype)typeView;

- (void)show:(typeButtonClickBlock)block;
- (void)hidden;


@end
