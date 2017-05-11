//
//  ActionSheetModelView.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/8.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "ActionSheetModelView.h"
@interface ActionSheetModelView()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end


@implementation ActionSheetModelView

+(instancetype)actionWithModel:(ActionSheetModel *)model
{
    UINib *nib = [UINib nibWithNibName:@"ActionSheetModelView" bundle:nil];
    
    ActionSheetModelView *instance = [nib instantiateWithOwner:nil options:nil][0];
    
    instance.iconImage.image = [UIImage imageNamed:model.iconName];
    instance.title.text = model.title;
    instance.subTitle.text = model.subTitle;
    
    return instance;
}

@end
