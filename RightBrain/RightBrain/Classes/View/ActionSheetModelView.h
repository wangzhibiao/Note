//
//  ActionSheetModelView.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/8.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetModel.h"

@interface ActionSheetModelView : UIView

@property (nonatomic, strong) ActionSheetModel *model;


+(instancetype)actionWithModel:(ActionSheetModel *)model;

@end
