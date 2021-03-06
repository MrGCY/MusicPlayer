//
//  CYLrcModel.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
//歌词数据
@interface CYLrcModel : NSObject
/** 开始时间 */
@property (nonatomic ,assign) NSTimeInterval beginTime;

/** 结束时间 */
@property (nonatomic ,assign) NSTimeInterval endTime;

/** 歌词内容 */
@property (nonatomic ,copy) NSString *lrcText;
@end
