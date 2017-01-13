//
//  ESTabView.h
//  ESTabView
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTabBar.h"

@class ESTabView;

@protocol ESTabViewDelegate <NSObject>

@optional

- (void)tabView:(ESTabView *)tabView willDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index;
- (void)tabView:(ESTabView *)tabView willEndDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index;

- (void)tabView:(ESTabView *)tabView didDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index;
- (void)tabView:(ESTabView *)tabView didEndDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index;

@end


@interface ESTabView : UIView

@property (strong, nonatomic, readonly) ESTabBar *tabBar;

@property (strong, nonatomic, readonly) UIScrollView *scrollView;

@property (strong, nonatomic, readonly) NSArray<__kindof UIView *> *views;

@property (assign, nonatomic, readonly) NSInteger currentIndex;

@property (strong, nonatomic, readonly) __kindof UIView *currentContentView;

@property (weak, nonatomic) id<ESTabViewDelegate> delegate;

- (void)setItemsWithViews:(NSArray<__kindof UIView *> *)views titles:(NSArray<NSString *> *)titles index:(NSInteger)index;

- (void)setItemTitle:(NSString *)title forIndex:(NSUInteger)index;

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated;

@end
