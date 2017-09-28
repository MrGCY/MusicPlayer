//
//  CYLrcCell.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYLrcCell.h"
@implementation CYLrcCell

/**
 *  重写歌词内容set方法, 展示歌词
 *
 *  @param lrcText 歌词内容
 */
- (void)setLrcText:(NSString *)lrcText
{
    _lrcText = lrcText;
    self.lrcLabel.text = lrcText;
}

/**
 *  设置歌词播放进度
 *
 *  @param progress 歌词进度
 */
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.lrcLabel.progress = progress;
}
@end
