//
//  NSDate+FormatStr.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "NSDate+FormatStr.h"

@implementation NSDate (FormatStr)

- (NSString *)nowDateFormatStr:(NSString *)formatterStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = formatterStr;
    
    return [format stringFromDate:self];
}

- (NSString *)nowDateWeekStr
{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日", @"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",  nil];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:self];
    // 获取今天是周几
    NSInteger week = [comp weekday];
    return [NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week-1]];
}

+(NSString *)dateStrWithStr:(NSString *)dateStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *date = [format dateFromString:dateStr];
    
    format.dateFormat = @"yyyy-MM-dd";
    
    return [format stringFromDate:date];
}

@end
