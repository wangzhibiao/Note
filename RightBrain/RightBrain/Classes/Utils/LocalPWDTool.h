//
//  LocalPWDTool.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/5.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPWDTool : NSObject

+ (NSString *)getPwd;
+ (void)savePwd:(NSString *)pwd;
@end
