//
//  CYMusicDetailViewController.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYMusicDetailViewController.h"
#import "CYLrcLabel.h"
#import "CYMusicOperationManager.h"
#import "CYMusicInfoModel.h"
#import "CYTimeUtils.h"
#import "CYLrcModel.h"
#import "CYMusicModel.h"
#import "UIView+Extension.h"
#import "CYLrcTableViewController.h"
#import "CALayer+PauseAimate.h"
#import "CYAudioUtils.h"
#import "CYLrcDataUtils.h"
#import "CYMusicDataUtils.h"

@interface CYMusicDetailViewController ()<UIScrollViewDelegate>

/** 歌词的占位背景视图 */
@property (weak, nonatomic) IBOutlet UIScrollView *lrcBackView;

/** 以下控件都是需要赋值的, 根据更新频率采取不同的方案 **/

/**********************1次*******************/

/** 背景图片 */
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

/** 歌手头像 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

/** 歌曲名称 */
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

/** 歌手名称 */
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;

/** 歌曲总时长 */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

/**********************多次*******************/

/** 播放的歌词 */
@property (weak, nonatomic) IBOutlet CYLrcLabel *lrcLabel;

/** 歌曲已经播放的时长 */
@property (weak, nonatomic) IBOutlet UILabel *costTimeLabel;

/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

/** 播放暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;


/***************************以下属于其他功能实现的附加属性*********************************/

/** 显示歌词的view*/
@property (nonatomic, weak) CYLrcTableViewController *lrcViewController;

/** 用来刷新界面的timer */
@property (nonatomic, strong) NSTimer *updateTimer;

/** 负责更新歌词的定时器 */
@property (nonatomic, strong) CADisplayLink *updateLrcLink;
@end

@implementation CYMusicDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 取出数据模型
    CYMusicModel *musicModel = [CYMusicOperationManager sharedInstance].musicModels.firstObject;
    
    // 播放音乐
    [[CYMusicOperationManager sharedInstance] playMusicWithMusicModel:musicModel];
    
    // 初始化设置
    [self setUpInit];
}

/**
 *  当本控制器显示时, 再把timer添加进来
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpOnce];
    [self updateTimer];
    [self updateLrcLink];
}

/**
 *  当本控制器不显示时, 可以移除timer, 节省资源
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.updateTimer invalidate];
    self.updateTimer = nil;
    
    [self.updateLrcLink invalidate];
    self.updateLrcLink = nil;
}


#pragma mark - 初始化设置
- (void)setUpInit
{
    // 将歌词视图添加到背景占位
    [self.lrcBackView addSubview:self.lrcViewController.tableView];
    self.lrcBackView.pagingEnabled = YES;
    self.lrcBackView.delegate = self;
    self.lrcBackView.showsHorizontalScrollIndicator = NO;
    
    // 设置进度条图片
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    
    // 监听歌曲播放完成的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextMusic) name:kNotificationAudioPlayFinish object:nil];
}

/**
 *  当控制器销毁时, 移除通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 歌手头像旋转

/**
 *  开始旋转
 */
- (void)beginRotation
{
    [self.iconImageView.layer removeAnimationForKey:@"rotation"];
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 30;
    animation.keyPath = @"transform.rotation.z";
    animation.repeatCount = NSIntegerMax;
    animation.removedOnCompletion = NO;
    [self.iconImageView.layer addAnimation:animation forKey:@"rotation"];
}

/**
 *  暂停旋转(此处的实现, 是使用到了一个CALayer分类, 来暂停核心动画)
 */
- (void)pauseRotation
{
    [self.iconImageView.layer pauseAnimate];
}

/**
 *  继续旋转(此处的实现, 是使用到了一个CALayer分类, 来暂停核心动画)
 */
- (void)resumeRotation
{
    [self.iconImageView.layer resumeAnimate];
}


/**
 *  设置当前的状态栏为白色
 *
 *  @return 状态栏样式
 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  当视图被布局完成之后调用(因为直接在viewDidLoad方法中, 获取到得各个视图大小, 是在"豆腐块", 状态下的大小)
 */
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // 设置歌词视图的frame
    self.lrcViewController.tableView.frame = self.lrcBackView.bounds;
    self.lrcViewController.tableView.cy_x = self.lrcBackView.cy_width;
    
    // 设置歌词占位视图的contentSize
    self.lrcBackView.contentSize = CGSizeMake(self.lrcBackView.cy_width * 2.0, 0);
    
    // 设置歌手头像为圆形
    self.iconImageView.layer.cornerRadius = self.iconImageView.cy_width * 0.5;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderWidth = 6.0;
    self.iconImageView.layer.borderColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0].CGColor;
    
}

#pragma mark - lazy loading

/**
 *  负责更新进度等信息的timer
 *
 *  @return timer
 */
- (NSTimer *)updateTimer
{
    if (!_updateTimer) {
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setUpTimes) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
    }
    return _updateTimer;
}

/**
 *  懒加载歌词显示控制器
 *
 *  @return 歌词控制器; 详情界面展示的歌词, 统一由此控制器管理(展示, 滚动, 进度等)
 */
- (CYLrcTableViewController *)lrcViewController
{
    if (!_lrcViewController) {
        CYLrcTableViewController *lrcViewController = [[CYLrcTableViewController alloc] init];
        [self addChildViewController:lrcViewController];
        _lrcViewController = lrcViewController;
    }
    return _lrcViewController;
}

/**
 *  负责更新歌词的时钟
 *
 *  @return updateLrcLink
 */
- (CADisplayLink *)updateLrcLink
{
    if (!_updateLrcLink) {
        _updateLrcLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
        [_updateLrcLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _updateLrcLink;
}
/************************初始化设置, 以下方法不涉及业务逻辑, 写一次基本上就不用了**********************************/

#pragma mark - setUpOnce

/**
 *  歌曲切换时, 更新一次的情况
 */
- (void)setUpOnce
{
    // 获取工具类提供的播放音乐信息的数据模型(由工具类统一提供, 此处不需要关心如何获取, 只负责展示)
    CYMusicInfoModel *messageModel = [CYMusicOperationManager sharedInstance].musicInfoModel;
    
    // 专辑图片
    self.backImageView.image = [UIImage imageNamed:messageModel.musicModel.icon];
    self.iconImageView.image = [UIImage imageNamed:messageModel.musicModel.icon];
    
    // 歌曲
    self.songNameLabel.text = messageModel.musicModel.name;
    // 演唱者
    self.singerNameLabel.text = messageModel.musicModel.singer;
    // 播放总时长
    self.totalTimeLabel.text = [CYTimeUtils getFormatTimeWithTimeInterval:messageModel.totalTime];
    
    // 开始旋转图片
    [self beginRotation];
    if (messageModel.isPlaying) {
        [self resumeRotation];
    } else {
        [self pauseRotation];
    }
    
    // 加载歌曲对应的歌词资源
    NSArray *lrcModels = [CYLrcDataUtils getLrcModelsWithFileName:messageModel.musicModel.lrcname];
    
    // 给负责展示歌词的控制器赋值, 具体展示由歌词展示控制器负责, 此处只负责传值
    self.lrcViewController.lrcModels = lrcModels;
}

#pragma mark - setUpTimes

/**
 *  歌曲切换时, 更新多次的情况
 */
- (void)setUpTimes
{
    // 获取歌曲播放信息的数据模型
    CYMusicInfoModel *messageModel = [CYMusicOperationManager sharedInstance].musicInfoModel;
    
    // 已经播放的时间
    self.costTimeLabel.text = [CYTimeUtils getFormatTimeWithTimeInterval:messageModel.presentTime];
    
    // 播放进度
    self.progressSlider.value = messageModel.presentTime / messageModel.totalTime;
    
    self.playOrPauseBtn.selected = messageModel.isPlaying;
}

#pragma mark - updateLrc
- (void)updateLrc
{
    // 获取歌曲播放信息的数据模型
    CYMusicInfoModel *messageModel = [CYMusicOperationManager sharedInstance].musicInfoModel;
    
    // 计算当前播放时间, 对应的歌曲行号
    NSInteger row = [CYLrcDataUtils getRowWithCurrentTime:messageModel.presentTime lrcModels:self.lrcViewController.lrcModels];
    
    // 把需要滚动的行号, 交给歌词控制器统一管理, 让歌词控制器负责滚动
    self.lrcViewController.scrollRow = row;
    
    // 显示歌词label
    // 取出当前正在播放的歌词数据模型
    CYLrcModel *lrcModel = self.lrcViewController.lrcModels[row];
    self.lrcLabel.text = lrcModel.lrcText;
    
    // 计算一行歌词的播放进度
    self.lrcLabel.progress = (messageModel.presentTime - lrcModel.beginTime) / (lrcModel.endTime - lrcModel.beginTime);
    
    // 传值给歌词控制器, 让歌词控制器的歌词负责进度展示
    self.lrcViewController.progress = self.lrcLabel.progress;
    
    // 更新锁屏界面的信息
    [[CYMusicOperationManager sharedInstance] updateLockScreenInfo];
    
}

#pragma mark - UIScrollViewDelegate
/**
 *  在这个方法里面, 做一些动画效果
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取当前滚动的范围
    CGFloat scale = 1 - scrollView.contentOffset.x / scrollView.cy_width;
    // 设置需要透明度调整的控件
    self.lrcLabel.alpha = scale;
    self.iconImageView.alpha = scale;
}


/******************以下方法, 都是业务逻辑方法, 需要跟外界进行交互, 所以放在比较容易被看到的地方**********************/

#pragma mark - Event
/**
 *  关闭控制器
 */
- (IBAction)close {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  更多按钮
 */
- (IBAction)more
{
    NSLog(@"更多");
}

/**
 *  播放或者暂停(上一首, 下一首, 播放/暂停这些功能实现, 统一由LYMusicOperationTool工具类提供, 此控制器内部, 只负责业务逻辑调度)
 */
- (IBAction)playOrPause:(UIButton *)sender {
    // 更改按钮的播放状态
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [[CYMusicOperationManager sharedInstance] playCurrentMusic];
        [self resumeRotation];
    } else {
        [[CYMusicOperationManager sharedInstance] pauseCurrentMusic];
        [self pauseRotation];
    }
}

/**
 *  上一首
 */
- (IBAction)preMusic {
    [[CYMusicOperationManager sharedInstance] preMusic];
    [self setUpOnce];
}

/**
 *  下一首
 */
- (IBAction)nextMusic {
    [[CYMusicOperationManager sharedInstance] nextMusic];
    [self setUpOnce];
}

#pragma mark - 播放器进度条事件
/**
 *  当进度条点击下去的事件
 */
- (IBAction)touchDown {
    // 移除更新进度的timer
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

/**
 *  当进度条点击松开时的事件
 */
- (IBAction)touchUp {
    // 添加更新进度的timer
    [self updateTimer];
    
    // 获取当前播放的音乐信息数据模型
    CYMusicInfoModel *messageModel = [CYMusicOperationManager sharedInstance].musicInfoModel;
    
    // 计算当前播放的时间
    NSTimeInterval currentTime = messageModel.totalTime * self.progressSlider.value;
    
    // 根据当前时间, 确定歌曲播放的进度
    [[CYMusicOperationManager sharedInstance] seekToTimeInterval:currentTime];
}

/**
 *  当进度条值发生改变时调用
 */
- (IBAction)valueChange:(UISlider *)sender {
    // 获取当前播放的音乐信息数据模型
    CYMusicInfoModel *messageModel = [CYMusicOperationManager sharedInstance].musicInfoModel;
    
    // 计算当前播放的时间
    NSTimeInterval currentTime = messageModel.totalTime * sender.value;
    
    // 修改已经播放时长的label
    self.costTimeLabel.text = [CYTimeUtils getFormatTimeWithTimeInterval:currentTime];
    
}

/**
 *  当点击进度条任意一位置时调用的方法(tap手势)
 */
- (IBAction)seekToTime:(UITapGestureRecognizer *)sender {
    //为了解决手势冲突,造成的timer被移除情况
    [self updateTimer];
    
    // 获取当前播放的音乐信息数据模型
    CYMusicInfoModel *messageModel = [CYMusicOperationManager sharedInstance].musicInfoModel;
    
    // 获取手指触摸的点
    CGPoint point = [sender locationInView:self.progressSlider];
    
    // 计算触摸点在整个视图上的比例
    CGFloat scale = point.x / self.progressSlider.cy_width;
    
    // 更改进度条的值
    self.progressSlider.value = scale;
    
    // 计算当前播放的时间
    NSTimeInterval currentTime = messageModel.totalTime * self.progressSlider.value;
    
    // 根据当前时间, 确定歌曲的播放进度
    [[CYMusicOperationManager sharedInstance] seekToTimeInterval:currentTime];
    
}
//当音乐锁屏处理
/******************远程事件的接收**********************/
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        {
            [[CYMusicOperationManager sharedInstance] playCurrentMusic];
            break;
        }
        case UIEventSubtypeRemoteControlPause:
        {
            [[CYMusicOperationManager sharedInstance] pauseCurrentMusic];
            break;
        }
        case UIEventSubtypeRemoteControlNextTrack:
        {
            [[CYMusicOperationManager sharedInstance] nextMusic];
            break;
        }
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
            [[CYMusicOperationManager sharedInstance] preMusic];
            break;
        }
            
        default:
            break;
    }
    
    [self setUpOnce];
}

@end
