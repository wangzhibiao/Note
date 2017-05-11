//
//  NBTextAttachment.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/12.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBTextAttachment : NSTextAttachment

/**
 图片的名字
 */
@property (nonatomic, copy) NSString *imgName;

@property (nonatomic, assign) CGSize imageSize;


@end
