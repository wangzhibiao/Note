//
//  ImageCacheTool.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/13.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCacheTool : NSObject

+(instancetype)shared;

- (void)writeFileToCache:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)getImageForKey:(NSString *)key;

@end
