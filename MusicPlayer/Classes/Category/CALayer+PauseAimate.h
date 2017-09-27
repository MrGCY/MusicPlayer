//
//  CALayer+PauseAimate.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PauseAimate)
// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;
@end
