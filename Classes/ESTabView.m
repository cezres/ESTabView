//
//  ESTabView.m
//  ESTabView
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESTabView.h"


@interface ESTabView ()
<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    ESTabBar *_tabBar;
    UIScrollView *_scrollView;
}

@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger willDisplayIndex;
@property (assign, nonatomic) NSInteger willEndDisplayingIndex;

@end

@implementation ESTabView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.tabBar];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tabBar];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setItemsWithViews:(NSArray<__kindof UIView *> *)views titles:(NSArray<NSString *> *)titles index:(NSInteger)index {
    _views = [views copy];
    [_tabBar setTitles:titles];
    _index = -1;
    self.index = index;
    _tabBar.currentIndex = index;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UIView *view in views) {
        [_scrollView addSubview:view];
    }
    [self setNeedsLayout];
}

- (void)setItemTitle:(NSString *)title forIndex:(NSUInteger)index {
    [_tabBar setItemTitle:title forIndex:index];
}

- (void)moveToIndex:(NSInteger)index animated:(BOOL)animated {
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * index, 0) animated:animated];
    if (!animated) {
        [self scrollViewDidEndScrollingAnimation:_scrollView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat progress = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (progress <0 || progress>_views.count-1) {
        return;
    }
    _tabBar.contentOffset = progress;
    
    if ((NSInteger)progress == progress) {
        return;
    }
    if (progress > _index) {
        self.willDisplayIndex = (NSInteger)progress + 1;
    }
    else if (progress < _index) {
        self.willDisplayIndex = (NSInteger)progress;
    }
    self.willEndDisplayingIndex = _index;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    self.index = (NSInteger)scrollView.contentOffset.x / scrollView.bounds.size.width;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    self.index = (NSInteger)scrollView.contentOffset.x / scrollView.bounds.size.width;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    _tabBar.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    _scrollView.frame = CGRectMake(0, 44, self.bounds.size.width, self.bounds.size.height-44);
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width * _index, 0);
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * _views.count, 0);
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(_scrollView.bounds.size.width * idx, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }];
}


#pragma mark - Set

- (void)setIndex:(NSInteger)index {
    _willDisplayIndex = -1;
    _willEndDisplayingIndex = -1;
    if (_index >= 0 && _index != index) {
        if ([self.delegate respondsToSelector:@selector(tabView:didEndDisplayView:forItemIndex:)]) {
            [self.delegate tabView:self didEndDisplayView:_views[_index] forItemIndex:_index];
        }
    }
    _index = index;
    if ([self.delegate respondsToSelector:@selector(tabView:didDisplayView:forItemIndex:)]) {
        [self.delegate tabView:self didDisplayView:_views[_index] forItemIndex:_index];
    }
}

- (void)setWillDisplayIndex:(NSInteger)willDisplayIndex {
    if (_willDisplayIndex == willDisplayIndex) {
        return;
    }
    _willDisplayIndex = willDisplayIndex;
    if (_willDisplayIndex != -1) {
        if ([self.delegate respondsToSelector:@selector(tabView:willDisplayView:forItemIndex:)]) {
            [self.delegate tabView:self willDisplayView:_views[_willDisplayIndex] forItemIndex:_willDisplayIndex];
        }
    }
}

- (void)setWillEndDisplayingIndex:(NSInteger)willEndDisplayingIndex {
    if (_willEndDisplayingIndex == willEndDisplayingIndex) {
        return;
    }
    _willEndDisplayingIndex = willEndDisplayingIndex;
    if (_willEndDisplayingIndex != -1) {
        if ([self.delegate respondsToSelector:@selector(tabView:willEndDisplayView:forItemIndex:)]) {
            [self.delegate tabView:self willEndDisplayView:_views[_willEndDisplayingIndex] forItemIndex:_willEndDisplayingIndex];
        }
    }
}

#pragma mark - Get

- (NSInteger)currentIndex {
    return _index;
}

- (UIView *)currentContentView {
    return _views[_index];
}

- (ESTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[ESTabBar alloc] init];
        _tabBar.color = [UIColor colorWithWhite:200/255.0 alpha:1.0];
        _tabBar.selectedColor = [UIColor colorWithRed:216/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
        _tabBar.edgeInsets = UIEdgeInsetsMake(4, 15, 4, 15);
        _tabBar.spacing = 15;
        _tabBar.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakself = self;
        [_tabBar setOnClickItem:^(NSInteger idx) {
            [weakself moveToIndex:idx animated:NO];
        }];
    }
    return _tabBar;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
