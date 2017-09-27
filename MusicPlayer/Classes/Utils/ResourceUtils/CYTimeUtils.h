//
//  CYTimeUtils.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYTimeUtils : NSObject
/**
 *  根据秒数, 转换成为 "分钟:秒数" 的格式 , 例如 "06:02"
 *
 *  @param timeInterval 秒数
 *
 *  @return 转换后的时间格式
 */
+ (NSString *)getFormatTimeWithTimeInterval:(NSTimeInterval)timeInterval;


/**
 *  根据  "分钟:秒数" 的格式 , 例如 "06:02" 转换成为 秒数
 *
 *  @param format 格式化的时间
 *
 *  @return 秒数
 */
+ (NSTimeInterval)getTimeIntervalWithFormatTime:(NSString *)format;
@end
