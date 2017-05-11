//
//  TableViewHeaderView.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "TableViewHeaderView.h"

@implementation TableViewHeaderView

+ (instancetype)instance
{
    UINib *nib = [UINib nibWithNibName:@"TableViewHeaderView" bundle:nil];
    
    return [nib instantiateWithOwner:nil options:nil][0];
}

@end
