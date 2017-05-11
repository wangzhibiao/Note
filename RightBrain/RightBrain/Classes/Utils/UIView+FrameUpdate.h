//
//  UIView+FrameUpdate.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameUpdate)

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;
- (void)setSize:(CGSize)size;

- (void)setY:(CGFloat)y;
- (void)setX:(CGFloat)x;
- (CGFloat)x;
- (CGFloat)y;
@end
