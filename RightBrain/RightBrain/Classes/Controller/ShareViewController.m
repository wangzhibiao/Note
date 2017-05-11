//
//  ShareViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/7.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "ShareViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "ActionSheetModel.h"
#import "PicAndTextActionSheet.h"
#import <Photos/Photos.h>
#import "NBTextAttachment.h"

@interface ShareViewController ()<UIImagePickerControllerDelegate, DownSheetDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分享预览";
    self.view.backgroundColor = golbal_color(254, 250, 220);
    // 设置导航栏
    [self setupNav];
    [self loadData];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)loadData
{
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.view);
        make.center.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
    }];
    // 设置文本框背景颜色
    self.textView.backgroundColor = golbal_bg_color;
    
    // 设置内通
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = txtMargin;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    NSMutableAttributedString *attrstr = [self attrbuteStringWithString:self.model];
    
    NSMutableAttributedString *logo = [[NSMutableAttributedString alloc] initWithString:@"\n\n\n 来自：@随便日记"];
    NSRange range = NSMakeRange(0, logo.length);
    [logo setAttributes:attributes range:range];
    
    [attrstr insertAttributedString:logo atIndex:attrstr.length];
    
    // 设置内容
    self.textView.attributedText = attrstr;
    // 设置字体
    self.textView.textColor = golbal_text_color;
    

    [self.textView setNeedsDisplay];
}

#pragma mark - 由文本转换图片替换
- (NSMutableAttributedString *)attrbuteStringWithString:(NoteModel *)model
{
    NSAttributedString *str;
    if (model){
        str = model.noteBody;
    }else {
        str = self.attrStr;
    }
    
    NSLog(@"***********str:%@",str);
    // 文本的属性文本
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithAttributedString: str];
    
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
        
        
        
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            // 设置图片
            attachment.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentUrl, imageName]];
        
        
//        attachment.image = [UIImage imageNamed:[NSURL r]];
        
            //设置image的尺寸
            CGFloat scale = (attachment.image.size.height / attachment.image.size.width);
            CGFloat width = (SCREEN_WIDTH - 30);
            attachment.bounds = CGRectMake(5, 0, width, (width * scale));
//        attachment.bounds = CGRectMake(5, 0, width, 200);

        
            // 图片等属性文本
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            
            // 替换图片文本
            [attrText replaceCharactersInRange:r withAttributedString:textAttachmentString];
            
//        });
        
    }
    // 因为图片文本没有字体属性 所以每次设置完要手动添加
    [attrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attrText.length)];
    
    return attrText;
}




#pragma mark - 设置导航栏
- (void)setupNav
{
    // 左边
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-white~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边
//    UIBarButtonItem *savePic =
//    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"savepho"] style:UIBarButtonItemStylePlain target:self action:@selector(savePhotoClick)];
    

    
    UIBarButtonItem *sharePic = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"action-hd~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(sharePhotoClick)];
    
    self.navigationItem.rightBarButtonItems = @[sharePic];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark - 取消按钮点击方法
- (void)dismis
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片按钮点击
- (void)savePhotoClick
{

    // 提示图标
    [SVProgressHUD show];
    // 获取截图保存到相册
    UIImage *image = [self saveLongImage:self.textView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
/**   [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest  creationRequestForAssetFromImage:image];
        
        PHAssetCollection *album = [[PHAssetCollection alloc] init];
        
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        
        
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];
        [albumChangeRequest addAssets:@[assetPlaceholder]];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (!success)
        {
            [SVProgressHUD showErrorWithStatus:@"保存相册失败"];
            NSLog(@"error: %@",error);
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"保存相册成功"];
        }
        // 1 秒消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

    }];
    **/
}




#pragma mark - 保存相册监听
- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        [SVProgressHUD showErrorWithStatus:@"保存相册失败"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存相册成功"];
    }
    // 1 秒消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}




#pragma mark - 分享按钮点击
- (void)sharePhotoClick
{
    
    ActionSheetModel *model2 = [ActionSheetModel new];
    model2.iconName = @"pengyouquan";
    model2.title = @"分享到微信朋友圈";
    
    ActionSheetModel *model1 = [ActionSheetModel new];
    model1.iconName = @"weixin~iphone";
    model1.title = @"分享到微信好友";
    
//    ActionSheetModel *model3 = [ActionSheetModel new];
//    model3.iconName = @"icon-weibo~iphone";
//    model3.title = @"分享到微博";
    
    ActionSheetModel *model4 = [ActionSheetModel new];
    model4.iconName = @"savepho";
    model4.title = @"保存长图片到相册";
    
    NSArray *items = [NSArray array];
    if ([WXApi isWXAppInstalled]){
    
        items = @[model1, model2, model4];
    }else{
        items = @[model4];
    }
    
    PicAndTextActionSheet *shareV = [[PicAndTextActionSheet alloc] initWithList:items title:@"日记会以长图片的方式分享"];

    shareV.delegate = self;
    [shareV showInView:self.navigationController];
    
}

// 代理反复
- (void)didSelectIndex:(NSInteger)index
{
    if ([WXApi isWXAppInstalled]){
        switch (index) {
            case 1:
            case 2:
                [self WXShareWithType:index-1];
                break;
                
            default:
                [self savePhotoClick];
                break;
        }
    }else {
        [self savePhotoClick];
    }
}


#pragma mark - 分解类型分享
- (void)WXShareWithType:(NSInteger)type
{
        UIImage *image = [self saveLongImage:self.textView];
        
        WXMediaMessage *msg = [WXMediaMessage message];
        
        [msg setThumbImage:image];
        
        WXImageObject *img = [WXImageObject object];
        img.imageData = UIImageJPEGRepresentation(image, 1.0);
        
        msg.mediaObject = img;
        
        SendMessageToWXReq *req = [SendMessageToWXReq new];
        req.bText = NO;
        req.message = msg;
        req.scene = (int)type;
        [WXApi sendReq:req];
        
}



#pragma mark -  截取长图
-(UIImage *)saveLongImage:(UITextView *)scrollView {
    
    UIImage* image = nil;

    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    
    CGRect frame = scrollView.frame;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    // 恢复视觉效果
    scrollView.frame = frame;
    
    return image;
}




@end
