//
//  RBDataTool.h
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoteModel;

@interface RBDataTool : NSObject
+(instancetype)shared;

-(void)insertNote:(NoteModel *)note;
-(void)deleateNote:(NoteModel *)note;
-(void)updateNote:(NoteModel *)note;
-(NSMutableArray *)selectNotes:(NSInteger)page;
@end
