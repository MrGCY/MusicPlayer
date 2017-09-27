//
//  CYAudioUtils.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
extern NSString * const kNotificationAudioPlayFinish;
@interface CYAudioUtils : NSObject
/**
 *  根据文件名, 播放一首音乐
 *
 *  @param audioName 文件名
 *
 *  @return 当前播放器
 */
- (AVAudioPlayer *)playAudioWithFileName:(NSString *)fileName;

/**
 *  暂停当前正在播放的音乐
 */
- (void)pauseAudio;

/**
 *  停止当前正在播放的音乐
 */
- (void)stopAudio;

/**
 *  设置当前播放器的播放进度
 *
 *  @param currentTime 播放时间
 */
- (void)seekToTimeInterval:(NSTimeInterval)currentTime;

@end
