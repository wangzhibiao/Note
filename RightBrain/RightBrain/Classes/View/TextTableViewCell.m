//
//  TextTableViewCell.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "TextTableViewCell.h"
#import "NoteModel.h"


@implementation TextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


#pragma mark - setter 方法更新数据
- (void)setModel:(NoteModel *)model
{
    _model = model;
    
    // 大于0 代表不是纯文字 要现实图片
    self.typeImage.hidden = !model.type;
    
    if (model.type){
        
        // 根据类型显示图
        NSString *imgName;
        NSString *titleName = model.noteBody.string;
        switch (model.type) {
            case 1:// 声音
                imgName = @"cm2_btmlay_btn_next";
                titleName = [titleName isEqualToString:@""] ? @"声音日记" : titleName;
                break;
            case 2:// 图片
                imgName = @"picture";
               
                titleName = [[self picNameReg:titleName] isEqualToString:@""] ? @"图文日记" : [self picNameReg:titleName];
                break;
            case 3:// 视频
                imgName = @"cm2_btmlay_btn_next";
                titleName = [titleName isEqualToString:@""] ? @"视频日记" : titleName;
                break;
            default:
                break;
        }
        
        // 设置图片
        self.typeImage.image = [UIImage imageNamed:imgName];
        // 设置标题
        self.noteTitle.text = titleName;
        
    }else {
        // 设置标题
        self.noteTitle.text = model.noteBody.string;
    }

}

/** 整理图片日记描述 */
- (NSString *)picNameReg:(NSString *)name
{
    
    NSMutableString *resultStr = [NSMutableString stringWithString:name];
    
    NSRange range = NSMakeRange(0, resultStr.length);
    
    // 正则检索文本的中的表情属性 做替换
    NSString *pattern = @"\\[.*?\\]";
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *result = [reg matchesInString:resultStr options:0 range:range];
    
    if (!result){
        return name;
    }
    
    for (NSTextCheckingResult *str in result.reverseObjectEnumerator) {
        
        NSRange r = [str rangeAtIndex:0];
        
        // 替换图片文本
        [resultStr replaceCharactersInRange:r withString:@""];
        
    }
    
    resultStr = [NSMutableString stringWithString: [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    return resultStr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
