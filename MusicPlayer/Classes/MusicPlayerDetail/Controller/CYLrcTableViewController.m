//
//  CYLrcTableViewController.m
//  MusicPlayer
//
//  Created by Mr.GCY on 2017/9/27.
//  Copyright © 2017年 Mr.GCY. All rights reserved.
//

#import "CYLrcTableViewController.h"
#import "CYLrcCell.h"
#import "CYLrcModel.h"
#import "UIView+Extension.h"
#define identifiCYLrcCell @"CYLrcCell"
// 渐进方向
typedef NS_OPTIONS(NSInteger, CYTableViewGradualDirection) {
    CYTableViewGradualDirectionTop                                         = 1 << 0, // top
    CYTableViewGradualDirectionBottom                                   = 1 <<  1,    // bottom
};
@interface CYLrcTableViewController ()

@end

@implementation CYLrcTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 控制器初始化方法
    [self setUpInit];
}
/**
 *  初始化方法
 */
- (void)setUpInit
{
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:identifiCYLrcCell bundle:nil] forCellReuseIdentifier:identifiCYLrcCell];
}
/**
 *  当控制器视图布局结束后调用(系统方法)
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 设置tableview内边距, 可以让第一行和最后一行歌词显示到中间位置
//    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.cy_height * 0.5, 0, self.tableView.cy_height * 0.5, 0);
    [self setupScrolldirection:(CYTableViewGradualDirectionTop | CYTableViewGradualDirectionBottom) gradualValue:@[@(.3), @0.3]];
}
/**
 *  重写歌词进度的set方法, 在此方法中, 设置歌词进度
 */
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    // 获取当前的行号
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.scrollRow inSection:0];
    
    // 取出对应的cell
    CYLrcCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // 设置进度
    cell.progress = progress;
}

/**
 *  重写歌词数据源的set方法, 在这个方法里面刷新表格
 *
 *  @param lrcModels 数据源
 */
- (void)setLrcModels:(NSArray<CYLrcModel *> *)lrcModels
{
    _lrcModels = lrcModels;
    [self.tableView reloadData];
}
/**
 *  重写需要滚动行的set方法, 在此方法里面滚动到对应的行
 *
 *  @param scrollRow 需要滚动的行号
 */
- (void)setScrollRow:(NSInteger)scrollRow
{
    // 通过这个判断, 过滤同一行的频繁刷新
    if (_scrollRow == scrollRow) {
        return;
    }
    _scrollRow = scrollRow;
    
    // 获取需要滚动的IndexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_scrollRow inSection:0];
    
    // 刷新表格
    [self.tableView reloadRowsAtIndexPaths:[self.tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationFade];
    
    // 滚动到对应行
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcModels.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 快速创建歌词cell
    CYLrcCell *cell = [tableView dequeueReusableCellWithIdentifier:identifiCYLrcCell];
    
    // 取出数据模型
    CYLrcModel *lrcModel = self.lrcModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 赋值
    cell.lrcText = lrcModel.lrcText;
    
    // 更新进度
    if (indexPath.row == self.scrollRow) {
        cell.progress = self.progress;
        cell.lrcLabel.font = [UIFont systemFontOfSize:18.0];
    } else {
        cell.progress = 0;
        cell.lrcLabel.font = [UIFont systemFontOfSize:15.0];
    }
    
    return cell;
}
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
    
    if (!self.tableView.layer.mask) {
        CAGradientLayer *maskLayer = [CAGradientLayer layer];
        maskLayer.locations = @[@0.0, topValue, @(1-bottomValue.doubleValue), @1.0f];
        maskLayer.bounds = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
        maskLayer.anchorPoint = CGPointZero;
        self.tableView.layer.mask = maskLayer;
    }
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self change];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self change];
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)change {
    UIScrollView *scrollView = (UIScrollView *)self.tableView;
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
