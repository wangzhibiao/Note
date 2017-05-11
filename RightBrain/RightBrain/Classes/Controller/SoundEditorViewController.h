//
//  SoundEditorViewController.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/9.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundEditorViewController : UIViewController

/** 模型数据 */
@property (nonatomic, strong) NoteModel *model;

// 一个标记用来表示是否处于编辑状态
@property (nonatomic, assign) BOOL isEditored;
@end
