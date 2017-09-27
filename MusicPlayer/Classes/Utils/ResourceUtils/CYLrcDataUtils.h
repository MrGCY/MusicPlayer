//
//  CYLrcDataUtils.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYLrcModel;
@interface CYLrcDataUtils : NSObject

/**
 *  根据歌词文件名称获取歌词
 *
 *  @param fileName 歌词文件名
 *
 *  @return 歌词数组
 */
+ (NSArray <CYLrcModel *> *)getLrcModelsWithFileName:(NSString *)fileName;

/**
 *  根据歌曲播放当前时间和歌词获取当前歌词行号
 *
 *  @param currentTime 歌曲播放当前的时间
 *  @param lrcModels   歌词数组
 *
 *  @return 行号
 */
+ (NSInteger)getRowWithCurrentTime:(NSTimeInterval)currentTime lrcModels:(NSArray <CYLrcModel *> *)lrcModels;
@end
