//
//  ESTabView.m
//  TabbarDemo
//
//  Created by 翟泉 on 16/3/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESTabView.h"

#define TabBarHeight 38.0

#define ColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface ESTabView ()
<
ESTabBarDelegate,
UIScrollViewDelegate
>
{
    CGSize _size;
    
    
    
}



@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation ESTabView

- (instancetype)initWithFrame:(CGRect)frame; {
    if (self = [super initWithFrame:frame]) {
        _currentIndex = -1;
        
    }
    return self;
}

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated; {
    if (index >= _views.count) {
        return;
    }
    _currentIndex = -1;
    self.currentIndex = index;
    [self.scrollView setContentOffset:CGPointMake(_currentIndex * self.scrollView.frame.size.width, 0) animated:YES];
}

- (UIView *)contentViewWithIndex:(NSInteger)index; {
    if (_views.count > index) {
        return _views[index];
    }
    else {
        return NULL;
    }
}

- (__kindof UIView *)currentContentView; {
    if (self.currentIndex >= self.views.count) {
        return NULL;
    }
    else {
        return self.views[self.currentIndex];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex; {
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    self.tabBar.selectedIndex = currentIndex;
    self.scrollView.contentOffset = CGPointMake(currentIndex * self.scrollView.frame.size.width, 0);
    
    [self.delegate tabView:self didMoveToIndex:_currentIndex];
}


#pragma mark - ESTabBarDelegate
- (void)tabbar:(ESTabBar *)tabbar selectedIndex:(NSInteger)index; {
    if (index == _currentIndex) {
        return;
    }
    self.currentIndex = index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    self.currentIndex = (NSInteger)self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    self.currentIndex = (NSInteger)self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
}


#pragma mark - UI

- (void)setItemsWithViews:(NSArray<__kindof UIView *> *)views titles:(NSArray<NSString *> *)titles; {
    if (views.count != titles.count) {
        return;
    }
    
    [self.views removeAllObjects];
    [_views addObjectsFromArray:views];
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    __weak typeof(self) weakself = self;
    [_views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakself.scrollView addSubview:obj];
    }];
    
    [self.tabBar setTabWithTitles:titles];
    
    _size = CGSizeZero;
    [self setNeedsLayout];
    
    self.currentIndex = _currentIndex==-1? 0:_currentIndex;
}

- (void)insertItemWithView:(__kindof UIView *)view title:(NSString *)title atIndex:(NSUInteger)index; {
    [_views insertObject:view atIndex:index];
    [_scrollView addSubview:view];
    
    [_tabBar insertTabWithTitle:title atIndex:index];
    
    _size = CGSizeZero;
    [self setNeedsLayout];
}
- (void)removeItemAtIndex:(NSUInteger)index; {
    if (self.currentIndex == index) {
        [self moveToIndex:0 animated:NO];
    }
//    else {
//        NSInteger _index = _currentIndex;
//        _currentIndex = -1;
//        self.currentIndex = _index;
//    }
    
    [_views[index] removeFromSuperview];
    [_views removeObjectAtIndex:index];
    
    
    [self.tabBar removeTabAtIndex:index];

    _size = CGSizeZero;
    [self setNeedsLayout];
}

- (void)setView:(__kindof UIView *)view forItemAtIndex:(NSUInteger)index; {
    [_views[index] removeFromSuperview];
    view.frame = _views[index].frame;
    [_scrollView addSubview:view];
    [_views replaceObjectAtIndex:index withObject:view];
}
- (void)setTitle:(NSString *)title forItemAtIndex:(NSUInteger)index; {
    [_tabBar setTitle:title forItemAtIndex:index];
}



- (void)layoutSubviews; {
    if (CGSizeEqualToSize(self.frame.size, _size)) {
        return;
    }
    _size = self.frame.size;
    
    self.tabBar.frame = CGRectMake(0, 0, self.frame.size.width, TabBarHeight);
    self.scrollView.frame = CGRectMake(0, TabBarHeight, self.frame.size.width, self.frame.size.height-TabBarHeight);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * _views.count, 0);
    
    __weak typeof(self) weakself = self;
    [_views enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(idx*weakself.scrollView.frame.size.width, 0, weakself.scrollView.frame.size.width, weakself.scrollView.frame.size.height);
    }];
    
    [super layoutSubviews];
}


#pragma mark - Lazy
- (UIScrollView *)scrollView; {
    if (!_scrollView) {
        _scrollView =[[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (ESTabBar *)tabBar; {
    if (!_tabBar) {
        _tabBar = [[ESTabBar alloc] init];
        _tabBar.backgroundColor = ColorRGB(255, 255, 255);
        _tabBar.tabbarDelegate = self;
        [self addSubview:_tabBar];
    }
    return _tabBar;
}
- (NSMutableArray<UIView *> *)views; {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

@end
