//
//  TextEditorViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/2.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "TextEditorViewController.h"
#import "ShareViewController.h"
#import "MainNavViewController.h"
#import "NBTextAttachment.h"
#import "ImageCacheTool.h"

@interface TextEditorViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/** 提交按钮 */
@property (nonatomic, strong) UIBarButtonItem *commitButton;
/**
 编辑按钮
 */
@property (nonatomic, strong) UIBarButtonItem *sharedButton;
/**
 插入图片
 */
@property (nonatomic, strong) UIBarButtonItem *picButton;
/** 手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGest;
/**
 获取设备照片控制器
 */
@property (nonatomic, strong) UIImagePickerController *imagePicerController;
/** 占位文字 */
@property (nonatomic, strong) UILabel *placeHolderLabel;

/**
 保存文章中的图片地址
 */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;


/** textkit 相关 */
@property (nonatomic, strong) NSTextContainer *txtContainer;



@end

@implementation TextEditorViewController


#pragma mark - 懒加载右侧的按钮
/** 确信按钮 */
- (UIBarButtonItem *)commitButton
{

    if (_commitButton == nil) {
        _commitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"productIsSending~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonClick)];
        _commitButton.enabled = NO;
    }
    return _commitButton;
}

/** 分享按钮 */
- (UIBarButtonItem *)sharedButton
{
    if (!_sharedButton) {
        _sharedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-pencil~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClick:)];
    }
    return _sharedButton;
}

/** 插入图片按钮 */
- (UIBarButtonItem *)picButton
{
    if (!_picButton) {
        _picButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"picture"] style:UIBarButtonItemStylePlain target:self action:@selector(picButtonClick)];
    }
    return _picButton;
}

#pragma mark - 存储照片地址的数组
- (NSArray *)imageUrlArray
{
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

/** 占位文字 */
- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel) {
        _placeHolderLabel = [UILabel new];
        _placeHolderLabel.text = @"写些有的没的...";
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:17];
        [_placeHolderLabel sizeToFit];
        
        // 约束
        _placeHolderLabel.x = 5;
        _placeHolderLabel.y = 8;
        [self.myTextView addSubview:_placeHolderLabel];
        
    }
    return _placeHolderLabel;
}

/** 文本编辑框 */
- (UITextView *)myTextView
{
    if (_myTextView == nil){
        _myTextView = [[UITextView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _myTextView;
}

/** 获取设备照片控制器 */
- (UIImagePickerController *)imagePicerController
{
    if (!_imagePicerController) {
        _imagePicerController = [[UIImagePickerController alloc] init];
        
        // 代理
        _imagePicerController.delegate = self;
    }
    return _imagePicerController;
}

/** 手势 */
- (UITapGestureRecognizer *)tapGest
{
    if (!_tapGest) {
        _tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestClick:)];
    }
    return _tapGest;
}



#pragma mark - 由文本转换图片替换
- (NSAttributedString *)attrbuteStringWithString:(NoteModel *)model
{
    
    // 文本的属性文本
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString: model.noteBody];
    
    NSRange range = NSMakeRange(0, attrText.length);

    // 正则检索文本的中的表情属性 做替换
    NSString *pattern = @"\\[.*?\\]";
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *result = [reg matchesInString:attrText.string options:0 range:range];
    
    if (!result){
        return attrText;
    }
    
    for (NSTextCheckingResult *str in result.reverseObjectEnumerator) {
        
        NSRange r = [str rangeAtIndex:0];
        NSRange nameRange = NSMakeRange(r.location + 1, r.length-2 );
        NSString *imageName = [attrText.string substringWithRange:nameRange];
        
        // 获取图片
        NBTextAttachment *attachment = [NBTextAttachment new];
        attachment.imgName = [NSString stringWithFormat:@"%@", imageName];
//        NSLog(@"获取图片路径：%@",[NSString stringWithFormat:@"%@/%@", documentUrl, imageName]);
        
        // 通过缓存取
        UIImage *imageCache = [[ImageCacheTool shared] getImageForKey:imageName];
        
        if (imageCache){
            
            CGFloat scale = (imageCache.size.height / imageCache.size.width);
            CGFloat width = (SCREEN_WIDTH - 30);
            CGSize imgSize = CGSizeMake(width, width * scale);
            // 设置图片
            attachment.image = [self imageWithImage:imageCache scaledToSize:imgSize];
            
        }else{
        
            // 设置图片
            UIImage *temp = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentUrl, imageName]];
            
            CGFloat scale = (temp.size.height / temp.size.width);
            CGFloat width = (SCREEN_WIDTH - 30);
            CGSize imgSize = CGSizeMake(width, width * scale);
            
            attachment.image = [self imageWithImage:temp scaledToSize:imgSize];;
            // 混存起来
            [[ImageCacheTool shared] writeFileToCache:temp forKey:imageName];
        }
        
        // 图片等属性文本
        NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        
        // 替换图片文本
        [attrText replaceCharactersInRange:r withAttributedString:textAttachmentString];

    }
    // 因为图片文本没有字体属性 所以每次设置完要手动添加
    [attrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attrText.length)];

    return attrText;
}

#pragma mark - 判断是否带有图片
- (BOOL)isHaveImage:(NoteModel *)model
{
    BOOL isHave = NO;
    // 文本的属性文本
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString: model.noteBody];
    
    NSRange range = NSMakeRange(0, attrText.length);
    
    NSLog(@"*******body: %@",attrText.string);
    
    // 正则检索文本的中的表情属性 做替换
    NSString *pattern = @"\\[.*?\\]";
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *result = [reg matchesInString:attrText.string options:0 range:range];
    
    if (result){
        isHave = YES;
    }else{
        isHave = NO;
    }
    
    return isHave;
}



#pragma mark -  定义文本属性 转换图片属性文本为字符串
- (NSString *)emoticonText
{
    // 返回属性
    __block NSString *result = @"";
    // 遍历属性文本 替换图片文本
    NSAttributedString *attrText = self.myTextView.attributedText;
    
    if (!attrText){
        return self.myTextView.attributedText.string;
    }
    
    // 包含图片文本 要便利替换掉
    NSRange range = NSMakeRange(0, attrText.length);
    
    [attrText enumerateAttributesInRange:range options: NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        NBTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment){
        
            result = [result stringByAppendingString:[NSString stringWithFormat:@"[%@]",attachment.imgName]];
            
            // 再次判断是否已经存在照片
            NSString *imgPath = [NSString stringWithFormat:@"%@/%@", documentUrl,attachment.imgName];
            NSFileManager *manager = [NSFileManager defaultManager];
            
            if (![manager fileExistsAtPath:imgPath]){
                
                [UIImageJPEGRepresentation(attachment.image, 0.2) writeToFile:imgPath atomically:YES];
                 NSLog(@"保存图片路径：%@",[NSString stringWithFormat:@"%@",imgPath]);
            }
            
            
        }else{
            NSString *str = [attrText.string substringWithRange:range];
            
            result = [result stringByAppendingString:str];
        }
    }];
    
    return result;
}



#pragma mark - 界面加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}



#pragma mark - 设置界面
- (void)setupUI
{
    // 背景颜色
    self.view.backgroundColor = golbal_bg_color;
    
    // 导航栏
    [self setupNav];
    
    // 文本框
    [self setupTextView];
}


#pragma mark - 在界面出现的时候加入通知 在页面消失的时候移除通知
- (void)viewWillAppear:(BOOL)animated
{
    // 这册键盘通知 监听键盘更改输入框的约束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 键盘通知方法
- (void)keyBoardWillShow:(NSNotification *)notification
{
    // 获取键盘的frame
    CGRect keyFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取动画时间
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 获取键盘高度
    CGFloat offSet = self.view.height - keyFrame.origin.y + 64;
    
    // 更改约束
    [self.myTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.center.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.bottom.equalTo(self.view).offset(-offSet);
    }];
    
    // 设置动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
    // 保存按钮
    [self textViewDidChange:self.myTextView];
    
}

- (void)keyBoardWillHide:(NSNotification *)notification
{

    // 恢复文本框的约束
    [self.myTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.center.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);

    }];
}




#pragma mark - 设置导航栏
- (void)setupNav
{
 
    // 中间title
    NSDate *now = [NSDate date];
    UILabel *title = [UILabel new];
    
    // 区分是否为新建
    if (self.model){
        // model的日期
        NSDateFormatter *ftm = [NSDateFormatter new];
        ftm.dateFormat = @"yyyy-MM-dd HH:mm";
        NSDate *date = [ftm dateFromString:self.model.noteDate];
        title.text = [NSString stringWithFormat:@"%@ \n %@",[date nowDateFormatStr:@"yyyy.MM.dd"], [date nowDateWeekStr]];
    }else{
        // 当前的日期
        title.text = [NSString stringWithFormat:@"%@ \n %@ ",[now nowDateFormatStr:@"yyyy.MM.dd"], [now nowDateWeekStr]];
    }
   
    title.textColor = [UIColor darkGrayColor];
    title.font = [UIFont systemFontOfSize:15 weight:1];
    title.numberOfLines = 0;
    title.textAlignment = NSTextAlignmentCenter;
    [title sizeToFit];
    [self.navigationItem setTitleView:title];
    
    // 左边
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-white~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边
    self.navigationItem.rightBarButtonItems = !self.isEditored ? @[self.sharedButton] : @[self.commitButton, self.picButton];
//     self.navigationItem.rightBarButtonItems = !self.isEditored ? @[self.sharedButton] : @[self.commitButton];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

}

#pragma mark - 设置文本框
- (void)setupTextView
{
    
    // 属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = txtMargin;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    // 文本框文字
    if (self.model){
        
        self.myTextView.attributedText = [self attrbuteStringWithString:self.model];

        // 加入💍
        [self.myTextView addGestureRecognizer:self.tapGest];
        
    }else{
        // 投机取巧 为了给textview赋值属性
        self.myTextView.attributedText = [[NSAttributedString alloc] initWithString:@"1" attributes:attributes];
         self.myTextView.attributedText = [[NSAttributedString alloc] initWithString:@"" attributes:attributes];
        // 调出键盘
        [self.myTextView becomeFirstResponder];
       
    }
    
    // 设置文本框背景颜色
    self.myTextView.backgroundColor = golbal_bg_color;
    // 光标颜色
    self.myTextView.tintColor = golbal_text_color;
    
    // 设置展位文字
    self.placeHolderLabel.hidden = !self.isEditored;

    // 设置字体
    self.myTextView.textColor = golbal_text_color;
    // 代理
    self.myTextView.delegate = self;
    self.myTextView.showsVerticalScrollIndicator = NO;
    self.myTextView.layoutManager.allowsNonContiguousLayout = NO;
    
    
    // 初始化文本输入框
    [self.view addSubview:self.myTextView];
    [self.myTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.center.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];

    [self textViewCanScroll];
    
}


#pragma mark - tetview可以滚动
- (void)textViewCanScroll
{
    // 设置可以拖动
    CGSize textSize = self.myTextView.contentSize;
    if (textSize.height <= SCREEN_HEIGHT){
        textSize.height = SCREEN_HEIGHT;
    }
    textSize = CGSizeMake(textSize.width, textSize.height + 30);
    self.myTextView.contentSize = textSize;
    

}


#pragma mark - 取消按钮点击方法
- (void)dismis
{
    [self.myTextView endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 确定按钮点击
- (void)commitButtonClick
{
    // 要判断是新建还是修改
    if (self.model) {
        // 修改
        self.model.noteBody = [[NSAttributedString alloc] initWithString: [self emoticonText]];
        
        [[RBDataTool shared] updateNote:self.model];
        
    }else {
        
        // 新建
        NoteModel *model = [NoteModel new];
        model.noteID = [NSString stringWithFormat:@"1%d",(arc4random() % 100000) + 1];
        model.noteBody = [[NSAttributedString alloc] initWithString: [self emoticonText]];
        model.noteDate = [[NSDate date] nowDateFormatStr:@"yyyy-MM-dd HH:mm"];
        
        // 避免重复保存的问题
        self.model = model;
        // 确定日记类型
        model.type = [self isHaveImage:model] ? 2 : 0;

        [[RBDataTool shared] insertNote:model];
    }
    
    // 取消键盘
    [self.myTextView endEditing:YES];
    
    // 顶部工具栏更改
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = @[self.sharedButton];
    
    // 加入手势
    [self.myTextView addGestureRecognizer:self.tapGest];
    
}



#pragma mark - 文本框代理方法
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    self.placeHolderLabel.hidden = textView.hasText;
    [self.myTextView setNeedsDisplay];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.myTextView endEditing:YES];
}


#pragma mark - 截屏分享
- (void)shareBtnClick:(UIBarButtonItem *)shareBtn
{
    // 获取展示控制器
    ShareViewController *shareVC = [ShareViewController new];
    if (self.model){
    
        shareVC.model = self.model;
    }else{
        shareVC.attrStr = self.myTextView.attributedText;
    }

    MainNavViewController *nav = [[MainNavViewController alloc] initWithRootViewController:shareVC];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark - 手势点击
- (void)tapGestClick:(UIGestureRecognizer *)tap
{
    // 移除
    [self.myTextView removeGestureRecognizer:self.tapGest];
    // 编辑文本
    self.myTextView.editable = YES;
    [self.myTextView becomeFirstResponder];
    
    // 光标移到电机位置
    CGPoint point = [tap locationInView:self.myTextView];
    UITextPosition * position=[self.myTextView closestPositionToPoint:point];
    [self.myTextView setSelectedTextRange:[self.myTextView textRangeFromPosition:position toPosition:position]];
    
    // 更改属性
    self.isEditored = YES;
    
    // 更改顶部工具栏
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = @[self.commitButton, self.picButton];
//     self.navigationItem.rightBarButtonItems = @[self.commitButton];
}

#pragma mark - 插入图片按钮点击
- (void)picButtonClick
{
    [self.myTextView endEditing:YES];
    
    // 菜单选择照片还是拍照
    UIAlertController *menuAlertController = [UIAlertController alertControllerWithTitle:@"选择获取图片方式" message:nil preferredStyle:0];

    // 拍照
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"拍照获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 设置类型
        self.imagePicerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 打开控制器
        [self.navigationController presentViewController:self.imagePicerController animated:YES completion:nil];
    }];
    
    // 相册获取
    UIAlertAction *libary = [UIAlertAction actionWithTitle:@"本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置类型
        self.imagePicerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 打开控制器
        [self.navigationController presentViewController:self.imagePicerController animated:YES completion:nil];
    }];
    
    // 取消
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    // 加入菜单
    [menuAlertController addAction:photo];
    [menuAlertController addAction:libary];
    [menuAlertController addAction:cancel];

    
    // 弹出菜单
    [self.navigationController presentViewController:menuAlertController animated:YES completion:nil];
    
    
}

/** 截取长图 */
-(UIImage *)saveLongImage:(UIScrollView *)scrollView {
    UIImage* image = nil;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);

    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 相机相册的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取照片资源
    UIImage *originImage = info[UIImagePickerControllerOriginalImage];
   
    // 创建照片插入到文本框
    NBTextAttachment *attach = [NBTextAttachment new];
    attach.imgName = [NSString stringWithFormat:@"%@.jpg",[[NSUUID UUID] UUIDString]];
    
    CGFloat scale = (originImage.size.height / originImage.size.width);
    CGFloat width = (SCREEN_WIDTH - 30);
    CGSize imgSize = CGSizeMake(width, width * scale);
    attach.image = [self imageWithImage:originImage scaledToSize:imgSize];
    
    // 插入文本框
    [self insetPic:attach];
    
    // 消失控制器
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/** 插入图片到文本编辑器 */
- (void)insetPic:(NBTextAttachment *)attachment
{
    // 文本的属性文本
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.myTextView.attributedText];
    
    // 光标位置
    NSRange range = [self.myTextView selectedRange];
    
    // 图片等属性文本
     NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 替换图片文本
    [attrText replaceCharactersInRange:range withAttributedString:textAttachmentString];
   
    // 插入空格
    NSMutableAttributedString *spaceStr = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    // 属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = txtMargin;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:golbal_text_color
                                 };
    [spaceStr addAttributes:attributes range:NSMakeRange(0, spaceStr.length)];
    [attrText addAttributes:attributes range:NSMakeRange(0, attrText.length)];

    
    // 赋值属性
    [attrText insertAttributedString:spaceStr atIndex:attrText.length];
    self.myTextView.attributedText = attrText;
    
    // 重置光标
    self.myTextView.selectedRange = NSMakeRange(range.location, 0);

    // 手动屌用文本更改
    [self textViewDidChange:self.myTextView];
    
    [self textViewCanScroll];
}

/** 重新绘制图片 性能好 */
-(UIImage *)imageWithImage:(UIImage*)image
               scaledToSize:(CGSize)newSize;
{
    // 并把它设置成为当前正在使用的context
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 2.0);
    }else{
        UIGraphicsBeginImageContext(newSize);
    }
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
