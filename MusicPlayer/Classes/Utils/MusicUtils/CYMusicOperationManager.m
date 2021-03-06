//
//  CYMusicOperationManager.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYMusicOperationManager.h"
#import "CYMusicDataUtils.h"
#import "CYAudioUtils.h"
#import "CYMusicModel.h"
#import "CYMusicInfoModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CYLrcDataUtils.h"
#import "CYLrcModel.h"
#import "CYImageUtils.h"

@interface CYMusicOperationManager()
/** 单个音乐播放的工具类 */
@property (nonatomic, strong) CYAudioUtils *audioTool;

/** 当前播放的索引 */
@property (nonatomic, assign) NSInteger currentIndex;

/** 当前正在播放的播放器对象*/
@property (nonatomic ,weak) AVAudioPlayer *audioCurrentPlayer;

/** 存放的播放列表 */
@property (nonatomic,readwrite, strong) NSArray <CYMusicModel *> *musicModels;

/** 歌曲信息数据模型 */
@property (nonatomic,readwrite,strong) CYMusicInfoModel * musicInfoModel;


@end
@implementation CYMusicOperationManager
+(instancetype)sharedInstance{
    static CYMusicOperationManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
/***********************懒加载, 或者重写的set方法***********************/
#pragma mark - 懒加载, 或者重写的set方法
-(NSArray<CYMusicModel *> *)musicModels{
    return [CYMusicDataUtils loadMusicData];
}
/**
 *  懒加载负责单首音乐播放的工具类
 *
 *  @return 音乐播放工具类
 */
-(CYAudioUtils *)audioTool{
    if (!_audioTool) {
        _audioTool = [[CYAudioUtils alloc] init];
    }
    return _audioTool;
}

/**
 *  重写音乐信息数据模型的get方法, 在这个方法里面保证数据的最新状态(此处利用的"拉模式", 不主动告诉外界最新信息, 让外界通过某些方法, 直接通过访问这个字段获取)
 *
 */
- (CYMusicInfoModel *)musicInfoModel
{
    if (!_musicInfoModel) {
        _musicInfoModel = [[CYMusicInfoModel alloc] init];
    }
    // 保证信息的最新状态
    _musicInfoModel.musicModel = self.musicModels[self.currentIndex];
    
    // 已播放时长
    _musicInfoModel.presentTime = self.audioCurrentPlayer.currentTime;

    // 总时长
    _musicInfoModel.totalTime = self.audioCurrentPlayer.duration;
    
    // 播放状态
    _musicInfoModel.isPlaying = self.audioCurrentPlayer.isPlaying;
    
    return _musicInfoModel;
}

/**
 *  重写当前播放索引的set方法, 在这个方法中进行过滤(防止错误数值的产生)
 *
 *  @param currentIndex 当前播放索引
 */
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    /**
     *  注意: 这里有个奇葩的事情, 将这两个判断调换下位置, 会出现一个神奇的bug(-10 > 0)
     *  解决方案: 建议直接将数组的个数取出来, 赋值给一个局部变量再进行判断(希望你们知道我在说啥...)
     */
    if (currentIndex < 0) {
        currentIndex = self.musicModels.count - 1;
    }
    if (currentIndex > self.musicModels.count - 1) {
        currentIndex = 0;
    }
    
    _currentIndex = currentIndex;
}

#pragma mark- 播放器相关东西
/**
 *  在播放某一首音乐对应的数据模型时, 计算出对应的索引
 *
 *  @param musicM 音乐数据模型
 */
- (void)playMusicWithMusicModel:(CYMusicModel *)musicModel
{
    self.audioCurrentPlayer = [self.audioTool playAudioWithFileName:musicModel.filename];
    
    //    _currentIndex = [self.musicModels indexOfObject:musicModel];
    
    NSArray *fileNames = [self.musicModels valueForKeyPath:@"filename"];
    self.currentIndex = [fileNames indexOfObject:musicModel.filename];
}

/**
 *  继续播放当前音乐
 */
- (void)playCurrentMusic
{
    // 取出当前正在播放的音乐数据模型
    CYMusicModel *musicModel = self.musicModels[self.currentIndex];
    [self playMusicWithMusicModel:musicModel];
}


/**
 *  暂停当前正在播放的音乐
 */
- (void)pauseCurrentMusic
{
    [self.audioTool pauseAudio];
}

/**
 *  播放上一首
 */
- (void)preMusic
{
    self.currentIndex --;
    [self playCurrentMusic];
}

/**
 *  播放下一首
 */
- (void)nextMusic
{
    self.currentIndex ++;
    [self playCurrentMusic];
}

/**
 *  根据时间, 设置播放器的进度
 *
 *  @param currentTime 播放时间
 */
- (void)seekToTimeInterval:(NSTimeInterval)currentTime
{
    [self.audioTool seekToTimeInterval:currentTime];
}
/**
 *  更新锁屏信息
 */
- (void)updateLockScreenInfo
{
    // 获取当前播放的数据模型
    CYMusicInfoModel *messageModel = self.musicInfoModel;
    
    // 获取当前锁屏的播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    UIImage *image = [UIImage imageNamed:messageModel.musicModel.icon];
    
    // 获取到当前播放的歌词, 然后, 绘制到图片上, 生成一个新的图片,当做专辑图片展示
    // 获取歌词
    NSArray *lrcModels = [CYLrcDataUtils getLrcModelsWithFileName:messageModel.musicModel.lrcname];
    
    NSInteger row = [CYLrcDataUtils getRowWithCurrentTime:messageModel.presentTime lrcModels:lrcModels];
    
    CYLrcModel *lrcModel = lrcModels[row];
    
    // 把歌词绘制到图片上
    image = [CYImageUtils createImageWithText:lrcModel.lrcText inImage:image];
    
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    
    // 赋值
    NSDictionary *dict = @{
                           MPMediaItemPropertyAlbumTitle : messageModel.musicModel.name, // 歌曲名称
                           MPMediaItemPropertyPlaybackDuration : @(messageModel.totalTime), // 歌曲总时长
                           MPNowPlayingInfoPropertyElapsedPlaybackTime : @(messageModel.presentTime), // 歌曲已经播放的时长
                           MPMediaItemPropertyArtist : messageModel.musicModel.singer,
                           MPMediaItemPropertyArtwork :  artwork
                           };
    
    center.nowPlayingInfo = dict;
    
    
    // 开启接收远程事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
@end
