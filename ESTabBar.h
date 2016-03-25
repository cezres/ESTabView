//
//  ESTabBar.h
//  TabbarDemo
//
//  Created by 翟泉 on 16/3/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define COUNT

@class ESTabBar;

@protocol ESTabBarDelegate <NSObject>

- (void)tabbar:(ESTabBar *)tabbar selectedIndex:(NSInteger)index;

@end

@interface ESTabBar : UIScrollView

//@property (strong, nonatomic) UIColor *barTintColor;
//@property (strong, nonatomic) UIColor *selectedTintColor;



@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) UIView *line;

@property (weak, nonatomic) id<ESTabBarDelegate> tabbarDelegate;
/**
 *  设置标签栏标签
 *
 *  @param titles <#titles description#>
 */
- (void)setTabWithTitles:(NSArray<NSString *> *)titles;
/**
 *  插入标签
 *
 *  @param title <#title description#>
 *  @param index <#index description#>
 */
- (void)insertTabWithTitle:(NSString *)title atIndex:(NSUInteger)index;
/**
 *  移除标签
 *
 *  @param index <#index description#>
 */
- (void)removeTabAtIndex:(NSUInteger)index;
/**
 *  设置指定标签的标题
 *
 *  @param title <#title description#>
 *  @param index <#index description#>
 */
- (void)setTitle:(NSString *)title forItemAtIndex:(NSUInteger)index;


@end
