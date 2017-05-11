//
//  TableViewHeaderView.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


+(instancetype)instance;

@end
