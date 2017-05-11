//
//  LocalPWDTool.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/5.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "LocalPWDTool.h"

@implementation LocalPWDTool

+ (NSString *)getPwd
{
    NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey: userPasswordKeyName];

    return pwd;
}
+ (void)savePwd:(NSString *)pwd
{

    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:userPasswordKeyName];
}

@end
