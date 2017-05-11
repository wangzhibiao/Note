//
//  SoundEditorViewController.m
//  RightBrain
//
//  Created by 王小帅 on 2017/3/9.
//  Copyright © 2017年 王小帅. All rights reserved.
//

#import "SoundEditorViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface SoundEditorViewController ()<UITextFieldDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate>
/** 提交按钮 */
@property (nonatomic, strong) UIBarButtonItem *commitButton;

/**
 名字输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *textFile;

/**
 录音视图
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/**
 录音提示文字
 */
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
/**
 录音点击图标按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *topButton;

/**
 回放视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**
 录音进度条
 */
@property (weak, nonatomic) IBOutlet UIProgressView *bottomProgress;
/**
 录音时长文字
 */
@property (weak, nonatomic) IBOutlet UILabel *bottomTimeLength;
/**
 录音播放按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;

/**
 录音对象
 */
@property (nonatomic, strong) AVAudioRecorder *myRecorder;

@property (nonatomic, strong) AVAudioSession *mySession;

@property (nonatomic, strong) NSString *soundPath;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int soundLength;

@property (nonatomic, strong) AVAudioPlayer *myPlayer;

@property (nonatomic, strong) NSTimer *updateProgressTimer;


@end

@implementation SoundEditorViewController

#pragma mark - 懒加载
/** 确信按钮 */
- (UIBarButtonItem *)commitButton
{
    
    if (_commitButton == nil) {
        _commitButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"productIsSending~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonClick)];
        _commitButton.enabled = NO;
    }
    return _commitButton;
}



#pragma mark - 录音工具类
- (AVAudioRecorder *)myRecorder
{
    if (!_myRecorder){
        
        // 设置文件路径
        if (!self.soundPath){
            NSString *recordUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *soundName = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".aac"];
            recordUrl = [recordUrl stringByAppendingPathComponent: soundName];
            self.soundPath = self.model ? self.model.aduio : recordUrl;
        }
//        NSLog(@"%@",self.soundPath);
        //录音设置
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
        //录音通道数  1 或 2
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        // 监听创建录音
        NSError *error = nil;
        
        _myRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:self.soundPath] settings:recordSetting error:&error];
        _myRecorder.delegate = self;
        
        if (error){
        
            NSLog(@"录音创建失败：%@",error);
            return nil;
        }
    }
    
    return _myRecorder;
}


#pragma mark - 播放器
- (AVAudioPlayer *)myPlayer
{
    if (!_myPlayer) {
    
        _myRecorder = self.myRecorder;

        NSError *error;
        _myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.soundPath] error:&error];
        
        if (error){
            NSLog(@"错误： %@",error.userInfo);
            return nil;
        }
        
        _myPlayer.delegate = self;
    }
    return _myPlayer;
}

- (NSTimer *)updateProgressTimer
{
    if (!_updateProgressTimer){
        _updateProgressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgressLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_updateProgressTimer forMode:NSRunLoopCommonModes];
    }
    return _updateProgressTimer;
}




#pragma mark - viewDidLoad 方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    // 注册光感控制器通知
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    
}

#pragma mark - 处理近距离监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//黑屏
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else//没黑屏幕
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}



#pragma mark - 设置视图
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 左边
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-white~iphone"] style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
    
    self.navigationItem.leftBarButtonItem = left;
    
    // 右边
    self.navigationItem.rightBarButtonItems = @[self.commitButton];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    // 设置显示
    self.topView.hidden = !self.isEditored;
    self.bottomView.hidden = self.isEditored;
    
    // 设置文本框
    if (!self.isEditored){
        self.textFile.text = self.model.noteBody.string;
        self.bottomTimeLength.text = self.model.duriationStr;
    }
    
    // 监听
    [self.textFile addTarget:self action:@selector(textFileChanged) forControlEvents:UIControlEventEditingChanged];
}



#pragma mark - 取消按钮点击方法
- (void)dismis
{
    [self.textFile endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 确定按钮点击
- (void)commitButtonClick
{
    // 要判断是新建还是修改
    if (self.model) {
        // 修改
        self.model.noteBody = self.textFile.attributedText;
        
        [[RBDataTool shared] updateNote:self.model];
        
    }else {
        
        // 新建
        NoteModel *model = [NoteModel new];
        model.noteID = [NSString stringWithFormat:@"1%d",(arc4random() % 100000) + 1];
        model.noteBody = self.textFile.attributedText;
        model.noteDate = [[NSDate date] nowDateFormatStr:@"yyyy-MM-dd HH:mm"];
        model.aduio = self.soundPath;
        model.duriationStr = [self timeLengthStr:self.soundLength];
        model.type = 1;
        
        [[RBDataTool shared] insertNote:model];
    }
    
    // 取消键盘
    [self.textFile endEditing:YES];
    // 更改状态
    self.isEditored = NO;
    
    [SVProgressHUD showSuccessWithStatus:@"保存完成"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
}



#pragma mark - 录音按钮点击
- (IBAction)topButtonClick:(UIButton *)sender {
    
    // 切换按钮状态
    sender.selected = !sender.isSelected;
    
    // 显示底部是图
    self.bottomView.hidden = sender.isSelected;
    // 更改字体显示
    self.topLabel.text = sender.isSelected ? @"正在录音..." : @"重新录制";
    self.topLabel.textColor = sender.isSelected ? [UIColor redColor] : [UIColor blackColor];
    
    // 更改底部录音信息视图
    if (!sender.isSelected){
        // 切换保存按钮状态
        self.commitButton.enabled = YES;
        
        [self stopRecoder];
        [self.bottomProgress setProgress:0];
        self.bottomTimeLength.text = [self timeLengthStr:self.soundLength];
        
    }else{
        // 切换保存按钮状态
        self.commitButton.enabled = NO;
        
        self.soundLength = 0;
        [self deleteOldSound];
        [self startRecoder];
    }
}

#pragma mark - 开始录音
- (void)startRecoder
{
    // 监听勃律
    _mySession = [AVAudioSession sharedInstance];
    
    NSError *sessionError;
    [_mySession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if (_mySession == nil) {
        
        NSLog(@"Error creating session: %@",[sessionError description]);
        
    }else{
        [_mySession setActive:YES error:nil];
        
    }
    
    // 设置扬声器
    [_mySession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    self.myRecorder.meteringEnabled = YES;
    [self.myRecorder prepareToRecord];
    [self.myRecorder record];
    // 增加定时器
    [self addTimer];
}



#pragma mark - 停止录音
- (void)stopRecoder
{
    [self removeTimer];
    self.bottomTimeLength.text = [self timeLengthStr:self.soundLength];
    
    if ([self.myRecorder isRecording]){
        [self.myRecorder stop];
    }
    
    // 清空所有
    _myPlayer = nil;
}


#pragma mark - 播放按钮点击
- (IBAction)bottomButtomClick:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected){
        [self startPlayer];
    }else{
        [self stopPlayer];
    }
}

#pragma mark - 开始播放
- (void)startPlayer
{
    
    if (self.myPlayer && ![self.myPlayer isPlaying]){
        
        self.updateProgressTimer.fireDate = [NSDate distantPast];
        [self.mySession setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [self.myPlayer play];
        
        // 播放中不能录音
        [self.topButton setEnabled:NO];
    }
}

#pragma mark - 停止播放
- (void)stopPlayer
{
    if ([self.myPlayer isPlaying]){
        self.updateProgressTimer.fireDate = [NSDate distantFuture];
        [self.myPlayer pause];
        
        // 播放中不能录音
        [self.topButton setEnabled:YES];
    }
}

#pragma mark - 监听播放完毕
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    // 设置进度条
    [self.bottomProgress setProgress:0 animated:NO];
    
    // 设置暂停为播放
    self.bottomButton.selected = !self.bottomButton.isSelected;
    // 播放中不能录音
    [self.topButton setEnabled:YES];
}


// 更新进度
- (void)updateProgressLabel
{
    // 进度条
    CGFloat progress = self.myPlayer.currentTime/self.myPlayer.duration;
    [self.bottomProgress setProgress:progress animated:YES];
}

#pragma mark - 播放代理方法



#pragma mark - 定时器方法
- (void)addTimer
{
    if (!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

// 移除定时器
- (void)removeTimer
{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

// 记录时间
- (void)timerCount
{
    self.soundLength++;
    self.topLabel.text = [self timeLengthStr:self.soundLength];
}

// 时间转换
- (NSString *)timeLengthStr:(int)length
{
    // 分钟
    int min = length / 60;
    // 秒
    int sec = length % 60;
    
    return [NSString stringWithFormat:@"%d 分钟 %d 秒", min, sec];
}

- (void)textFileChanged
{
    // 只要当没有录音的时候 才用它来判断 它的优先级低于录音
    if (self.model){
        self.commitButton.enabled = [self.textFile hasText];
    }
}



#pragma mark - 删除录音
- (void)deleteOldSound
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:self.soundPath]){
    
        NSError *error= nil;
        [manager removeItemAtPath:self.soundPath error:&error];
        if (error){
            NSLog(@"删除原来的录音失败!");
        }
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self.updateProgressTimer invalidate];
    self.updateProgressTimer = nil;
    [self.timer invalidate];
    self.timer = nil;
}


- (void)dealloc
{
    //删除近距离事件监听
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
