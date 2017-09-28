//
//  UITableView+GradientLayer.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/28.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "UITableView+GradientLayer.h"

@implementation UITableView (GradientLayer)
//设置滚动渐变的方向
-(void)setupScrolldirection:(CYTableViewGradualDirection)direction gradualValue:(id)gradualValue{
    NSNumber *topValue = @0, *bottomValue = @0;
    if (direction & CYTableViewGradualDirectionTop) {
        if ([gradualValue isKindOfClass:[NSNumber class]]) {
            topValue = gradualValue;
        } else {
            topValue = [(NSArray*)gradualValue firstObject];
        }
    }
    if (direction & CYTableViewGradualDirectionBottom) {
        if ([gradualValue isKindOfClass:[NSNumber class]]) {
            bottomValue = gradualValue;
        } else {
            bottomValue = [(NSArray*)gradualValue lastObject];
        }
    }
    
    if (!self.layer.mask) {
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.locations = @[@0.0, topValue, @(1-bottomValue.doubleValue), @1.0f];
        maskLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        self.layer.mask = maskLayer;
    }
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self change];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self change];
    }
}

- (void)removeTableObserve{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)change {
    UIScrollView *scrollView = (UIScrollView *)self;
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    NSArray *colors;
    
    if (scrollView.contentOffset.y + scrollView.contentInset.top <= 0) {
        //Top of scrollView
        colors = @[(__bridge id) innerColor, (__bridge id) innerColor,
                   (__bridge id) innerColor, (__bridge id) outerColor];
    } else if (scrollView.contentOffset.y + scrollView.frame.size.height
               >= scrollView.contentSize.height) {
        //Bottom of tableView
        colors = @[(__bridge id) outerColor, (__bridge id) innerColor,
                   (__bridge id) innerColor, (__bridge id) innerColor];
    } else {
        //Middle
        colors = @[(__bridge id) outerColor, (__bridge id) innerColor,
                   (__bridge id) innerColor, (__bridge id) outerColor];
    }
    ((CAGradientLayer *) scrollView.layer.mask).colors = colors;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}
@end
