//
//  CYLrcTableViewController.h
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYLrcModel;
@interface CYLrcTableViewController : UITableViewController
/** 外界传递过来的歌词数据源, 负责展示 */
@property (nonatomic, strong) NSArray <CYLrcModel *> *lrcModels;

/** 根据外界传递过来的行号, 负责滚动 */
@property (nonatomic, assign) NSInteger scrollRow;

/** 根据外界传递过来的歌词进度, 展示歌词进度 */
@property (nonatomic, assign) CGFloat progress;
@end
