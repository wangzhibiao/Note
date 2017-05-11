//
//  TextEditorViewController.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteModel;

@interface TextEditorViewController : UIViewController

// 文本狂
@property (nonatomic, strong) UITextView  *myTextView;

// 一个标记用来表示是否处于编辑状态
@property (nonatomic, assign) BOOL isEditored;

/** 模型数据 */
@property (nonatomic, strong) NoteModel *model;


@end
