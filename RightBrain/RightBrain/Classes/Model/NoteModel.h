//
//  NoteModel.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

/** id */
@property (nonatomic, copy) NSString *noteID;
/** 文字内容 如果是声音的话就是标题 */
@property (nonatomic, copy) NSAttributedString *noteBody;
/** 文章的日期 */
@property (nonatomic, copy) NSString *noteDate;
/** 文章的类型 0 ： 文字  1: 录音 2:图片 3:视频*/
@property (nonatomic, assign) int64_t type;

//@property (nonatomic, copy) NSString *tag;

/** 图片 */
@property (nonatomic, copy) NSString *pic;
/** 视频 */
@property (nonatomic, copy) NSString *video;
/** 声音 */
@property (nonatomic, copy) NSString *aduio;
/**
 录音或视频的时长
 */
@property (nonatomic, copy) NSString *duriationStr;

@end
