//
//  UIView+Extension.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat cy_centerX;
@property (nonatomic, assign) CGFloat cy_centerY;
@property (nonatomic, assign) CGFloat cy_x;
@property (nonatomic, assign) CGFloat cy_y;
@property (nonatomic, assign) CGFloat cy_width;
@property (nonatomic, assign) CGFloat cy_height;
@property (nonatomic, assign) CGSize cy_size;
@property (nonatomic, assign) CGPoint cy_origin;

- (NSString *)getNametag;

- (void)setNametag:(NSString *)theNametag;

- (UIView *)viewNamed:(NSString *)aName;
@end
