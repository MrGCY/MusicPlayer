//
//  CYImageUtils.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CYImageUtils : NSObject
/**
 *  根据一个图片,和一个文本, 将文本内容绘制到图片上面, 并生成一个新的图片
 *
 *  @param text  文本内容
 *  @param image 源图片
 *
 *  @return 处理后的图片
 */
+ (UIImage *)createImageWithText:(NSString *)text inImage:(UIImage *)image;
@end
