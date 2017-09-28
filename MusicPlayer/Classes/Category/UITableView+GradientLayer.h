//
//  UITableView+GradientLayer.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/28.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>
// 渐进方向
typedef NS_OPTIONS(NSInteger, CYTableViewGradualDirection) {
    CYTableViewGradualDirectionTop                                         = 1 << 0, // top
    CYTableViewGradualDirectionBottom                                   = 1 <<  1,    // bottom
};
@interface UITableView (GradientLayer)
//设置滚动渐变的方向
-(void)setupScrolldirection:(CYTableViewGradualDirection)direction gradualValue:(id)gradualValue;
- (void)removeTableObserve;
@end
