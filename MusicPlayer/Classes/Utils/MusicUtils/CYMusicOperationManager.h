//
//  CYMusicOperationManager.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class CYMusicModel,CYMusicInfoModel;

@interface CYMusicOperationManager : NSObject

/** 存放的播放列表 */
@property (nonatomic,readonly, strong) NSArray <CYMusicModel *> *musicModels;

/** 歌曲信息数据模型 */
@property (nonatomic,readonly,strong) CYMusicInfoModel * musicInfoModel;


+(instancetype)sharedInstance;
/**
 *  在播放某一首音乐对应的数据模型时
 *
 *  @param musicModel 音乐数据模型
 */
- (void)playMusicWithMusicModel:(CYMusicModel *)musicModel;

/**
 *  暂停当前正在播放的音乐
 */
- (void)pauseCurrentMusic;

/**
 *  继续播放当前音乐
 */
- (void)playCurrentMusic;

/**
 *  播放下一首
 */
- (void)nextMusic;

/**
 *  播放上一首
 */
- (void)preMusic;

/**
 *  设置播放的进度
 */
- (void)seekToTimeInterval:(NSTimeInterval)currentTime;

/**
 *  更新锁屏信息
 */
- (void)updateLockScreenInfo;
@end
