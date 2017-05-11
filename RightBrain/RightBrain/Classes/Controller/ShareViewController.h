//
//  ShareViewController.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/7.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteModel;

@interface ShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NoteModel *model;

@property (nonatomic, copy) NSAttributedString *attrStr;


@end
