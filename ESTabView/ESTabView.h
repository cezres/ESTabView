//
//  ESTabView.h
//  TabbarDemo
//
//  Created by 翟泉 on 16/3/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTabBar.h"



@class ESTabView;

@protocol ESTabViewDelegate <NSObject>

@optional
- (void)tabView:(ESTabView *)tabView didMoveToIndex:(NSInteger)index;

@end


@interface ESTabView : UIView

/**
 *  标签栏
 */
@property (strong, nonatomic) ESTabBar *tabBar;

@property (strong, nonatomic) NSMutableArray<__kindof UIView *> *views;

/**
 *  <#Description#>
 */
@property (assign, nonatomic, readonly) NSInteger currentIndex;

@property (strong, nonatomic) __kindof UIView *currentContentView;

@property (weak, nonatomic) id<ESTabViewDelegate> delegate;

/**
 *  设置标签视图
 *
 *  @param views  <#views description#>
 *  @param titles <#titles description#>
 */
- (void)setItemsWithViews:(NSArray<__kindof UIView *> *)views titles:(NSArray<NSString *> *)titles;
/**
 *  插入标签视图
 *
 *  @param view  <#view description#>
 *  @param title <#title description#>
 *  @param index <#index description#>
 */
- (void)insertItemWithView:(__kindof UIView *)view title:(NSString *)title atIndex:(NSUInteger)index;
/**
 *  移除
 *
 *  @param index <#index description#>
 */
- (void)removeItemAtIndex:(NSUInteger)index;
/**
 *  修改
 *
 *  @param view  <#view description#>
 *  @param index <#index description#>
 */
- (void)setView:(__kindof UIView *)view forItemAtIndex:(NSUInteger)index;
/**
 *  修改
 *
 *  @param title <#title description#>
 *  @param index <#index description#>
 */
- (void)setTitle:(NSString *)title forItemAtIndex:(NSUInteger)index;
/**
 *  获取内容视图对象
 *
 *  @param index <#index description#>
 *
 *  @return <#return value description#>
 */
- (__kindof UIView *)contentViewWithIndex:(NSInteger)index;
/**
 *  移动
 *
 *  @param index    <#index description#>
 *  @param animated <#animated description#>
 */
- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated;


@end
