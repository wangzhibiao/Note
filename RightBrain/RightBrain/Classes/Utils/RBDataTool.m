//
//  RBDataTool.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "RBDataTool.h"
#import <FMDB/FMDB.h>


@implementation RBDataTool

#pragma mark - 单例模式
static FMDatabase *_db;
static RBDataTool *instatnce;
+(instancetype)shared
{
    @synchronized (self) {
        
        if (!instatnce){
            instatnce = [RBDataTool new];
        }
        
        if (!_db){
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"note.db"];
            
            _db = [[FMDatabase alloc] initWithPath:path];
        }
        
        if (![_db open]){
            
            return instatnce;
        }
        
        // 创建表
        [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS Note(id integer PRIMARY KEY,note_model BLOB,note_date text NOT NULL,note_id text NOT NULL);"];
    }
    
    return instatnce;
}

/** 插入数据 */
-(void)insertNote:(NoteModel *)note
{

    // 模型归档
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note];
    // 插入数据库
    [_db executeUpdateWithFormat:@"INSERT INTO Note(note_id,note_date,note_model) VALUES(%@,%@,%@)",note.noteID,note.noteDate,data];
    
}
-(void)deleateNote:(NoteModel *)note
{
    [_db executeUpdateWithFormat:@"DELETE FROM Note WHERE note_id=%@",note.noteID];
}

-(void)updateNote:(NoteModel *)note
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:note];
    [_db executeUpdateWithFormat:@"UPDATE Note SET note_model=%@ WHERE note_id=%@",data,note.noteID];
}

/** 查询所愿记录 */
- (NSMutableArray *)selectNotes:(NSInteger)page
{
    // 要每次取20条数据 并且要倒叙
    NSInteger count = 20;
    NSInteger location = (page - 1) * count;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Note  ORDER BY strftime('%%Y-%%m-%%d %%HH:%%mm', note_date) DESC LIMIT %ld, %ld;",(long)location, (long)count];
    
    // 查询
    FMResultSet *set = [_db executeQuery:sql];
    
    // 临时数组
    NSMutableArray *temp = [NSMutableArray array];
    
    // 遍历所有
    while ([set next]) {
        
        // 取出model 的归档数据
        NSData *data = [set objectForColumnName:@"note_model"];
        
        // 接档为model
        NoteModel *noteModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        // 加入数组
        [temp addObject:noteModel];
        
    }
    
//    NSLog(@"array: %@",temp);
    return temp;
}


@end
