//
//  TextTableViewCell.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteModel;

@interface TextTableViewCell : UITableViewCell

@property (nonatomic, strong) NoteModel *model;


@property (weak, nonatomic) IBOutlet UILabel *noteTitle;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@end
