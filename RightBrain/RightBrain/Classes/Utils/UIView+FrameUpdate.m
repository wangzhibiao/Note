//
//  UIView+FrameUpdate.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "UIView+FrameUpdate.h"

@implementation UIView (FrameUpdate)

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame = CGRectMake(frame.origin.x , frame.origin.y , width, frame.size.height);
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    
    self.frame = frame;
}

-(CGFloat)width
{
    return self.frame.size.width;
}

-(CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}



@end
