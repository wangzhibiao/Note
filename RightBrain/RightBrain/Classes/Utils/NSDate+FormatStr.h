//
//  NSDate+FormatStr.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FormatStr)

- (NSString *)nowDateFormatStr:(NSString *)formatterStr;
- (NSString *)nowDateWeekStr;
+(NSString *)dateStrWithStr:(NSString *)dateStr;

@end
