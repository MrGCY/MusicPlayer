//
//  CYMusicDataUtils.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CYMusicModel;
@interface CYMusicDataUtils : NSObject
/**
 *  负责加载歌词列表的数据工具类
 *
 *  @param resultBlock 用于传递参数的回调block
 */
+ (NSArray <CYMusicModel *> *)loadMusicData;
@end
