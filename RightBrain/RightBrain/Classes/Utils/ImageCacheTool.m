//
//  ImageCacheTool.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/13.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "ImageCacheTool.h"

@interface ImageCacheTool()

@property (nonatomic, strong) NSCache *cache;


@end

@implementation ImageCacheTool

-(NSCache *)cache
{
    if (!_cache) {
        _cache = [NSCache new];
        
        _cache.totalCostLimit = 10*1024*1024;
    }
    return _cache;
}

static ImageCacheTool *instance = nil;
+(instancetype)shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        
    });
    
    return instance;
}

- (void)writeFileToCache:(UIImage *)image forKey:(NSString *)key
{
    [self.cache setObject:image forKey:key];
}

- (UIImage *)getImageForKey:(NSString *)key
{
    return [self.cache objectForKey:key];
}



@end
