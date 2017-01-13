//
//  ESTabBar.h
//  ESTabView
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ESTabBar : UIView

@property (assign, nonatomic) NSInteger currentIndex;

@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@property (assign, nonatomic) CGFloat spacing;

@property (assign, nonatomic) CGFloat contentOffset;

@property (copy, nonatomic) void (^onClickItem)(NSInteger index);

@property (strong, nonatomic) UIColor *color;

@property (strong, nonatomic) UIColor *selectedColor;

- (void)setTitles:(NSArray<NSString *> *)titles;

- (void)setItemTitle:(NSString *)title forIndex:(NSInteger)index;


@end
