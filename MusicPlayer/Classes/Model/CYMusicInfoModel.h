//
//  CYMusicInfoModel.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYMusicModel;
@interface CYMusicInfoModel : NSObject
/** 当前正在播放的音乐数据模型 */
@property (nonatomic ,strong) CYMusicModel *musicModel;

/** 当前播放的时长 */
@property(nonatomic ,assign) NSTimeInterval presentTime;

/** 当前播放总时长 */
@property(nonatomic ,assign) NSTimeInterval totalTime;

/** 当前的播放状态 */
@property(nonatomic ,assign) BOOL isPlaying;
@end
