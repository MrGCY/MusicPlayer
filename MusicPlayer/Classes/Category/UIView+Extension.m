//
//  UIView+Extension.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

static char nametag_key;
@implementation UIView (Extension)
#pragma mark - setter
- (void)setCy_centerX:(CGFloat)cy_centerX
{
    CGPoint center = self.center;
    center.x = cy_centerX;
    self.center = center;
}

- (void)setCy_centerY:(CGFloat)cy_centerY
{
    CGPoint center = self.center;
    center.y = cy_centerY;
    self.center = center;
}

- (void)setCy_x:(CGFloat)cy_x
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.x = cy_x;
    self.frame = tempFrame;
}

- (void)setCy_y:(CGFloat)cy_y
{
    CGRect tempFrame = self.frame;
    tempFrame.origin.y  = cy_y;
    self.frame = tempFrame;
}

- (void)setCy_width:(CGFloat)cy_width
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width = cy_width;
    self.frame = tempFrame;
}

- (void)setCy_height:(CGFloat)cy_height
{
    CGRect tempFrame = self.frame;
    tempFrame.size.height = cy_height;
    self.frame = tempFrame;
}

- (void)setCy_origin:(CGPoint)cy_origin
{
    CGRect frame = self.frame;
    frame.origin = cy_origin;
    self.frame = frame;
}

- (void)setCy_size:(CGSize)cy_size
{
    CGRect frame = self.frame;
    frame.size = cy_size;
    self.frame = frame;
}


#pragma mark - getter
- (CGFloat)cy_centerX
{
    return self.center.x;
}

- (CGFloat)cy_centerY
{
    return self.center.y;
}

- (CGFloat)cy_x
{
    return self.frame.origin.x;
}

- (CGFloat)cy_y
{
    return self.frame.origin.y;
}

- (CGFloat)cy_width
{
    return self.frame.size.width;
}

- (CGFloat)cy_height
{
    return self.frame.size.height;
}

- (CGPoint)cy_origin
{
    return self.frame.origin;
}

- (CGSize)cy_size
{
    return self.frame.size;
}


- (void)setNametag:(NSString *)theNametag {
    objc_setAssociatedObject(self, &nametag_key, theNametag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)getNametag {
    return objc_getAssociatedObject(self, &nametag_key);
}

- (UIView *)viewWithNameTag:(NSString *)aName {
    if (!aName) return nil;
    
    // Is this the right view?
    if ([[self getNametag] isEqualToString:aName])
        return self;
    // Recurse depth first on subviews;
    for (UIView *subview in self.subviews) {
        UIView *resultView = [subview viewNamed:aName];
        if (resultView) return  resultView;
    }
    // Not found
    return nil;
}

- (UIView *)viewNamed:(NSString *)aName {
    if (!aName) return nil;
    return [self viewWithNameTag:aName];
}

@end
