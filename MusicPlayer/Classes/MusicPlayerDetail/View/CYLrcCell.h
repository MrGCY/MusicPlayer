//
//  CYLrcCell.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLrcLabel.h"
@interface CYLrcCell : UITableViewCell
@property (weak, nonatomic) IBOutlet CYLrcLabel *lrcLabel;
/** 歌词内容 */
@property(nonatomic, copy) NSString *lrcText;

/** 歌词进度 */
@property(nonatomic, assign) CGFloat progress;
@end
