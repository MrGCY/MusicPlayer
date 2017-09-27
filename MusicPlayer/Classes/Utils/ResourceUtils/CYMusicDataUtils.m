//
//  CYMusicDataUtils.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYMusicDataUtils.h"
#import "CYMusicModel.h"
#import "MJExtension.h"

@implementation CYMusicDataUtils
+ (NSArray <CYMusicModel *> *)loadMusicData
{
    // 回调block
    // 此处的实现, 利用的字典转模型框架 MJExtension  , 注意方法名不要写错,(不要写成了传递路径的方法, 那个方法还需要获取文件路径)
    return [CYMusicModel mj_objectArrayWithFilename:@"Musics.plist"];
}
@end
