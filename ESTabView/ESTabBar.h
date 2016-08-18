//
//  ESTabBar.h
//  ESTabView
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ESTabBarStyle) {
    ESTabBarStyleNormal,
    ESTabBarStyleScroll
};


@interface ESTabBar : UIView

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic, readonly) ESTabBarStyle style;

@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@property (assign, nonatomic) CGFloat spacing;

@property (assign, nonatomic) CGFloat contentOffset;

@property (copy, nonatomic) void (^onClickItem)(NSInteger index);


- (instancetype)initWithStyle:(ESTabBarStyle)style;

- (void)setTitles:(NSArray<NSString *> *)titles;

- (void)setTintColorR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

- (void)setSelectedTintColorR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;

- (void)setItemTitle:(NSString *)title forIndex:(NSInteger)index;


@end
