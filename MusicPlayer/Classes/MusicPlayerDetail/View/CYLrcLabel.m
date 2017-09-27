//
//  CYLrcLabel.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYLrcLabel.h"

@implementation CYLrcLabel

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 设置颜色
    [[UIColor greenColor] set];
    
    CGRect fillRect = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
    
    //    UIRectFill(fillRect);
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

@end
