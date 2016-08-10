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
    ESTabBarStyle _style;
    UIScrollView *_scrollView;
}

@property (assign, nonatomic) NSInteger index;

@end

@implementation ESTabView

- (instancetype)initWithStyle:(ESTabBarStyle)style {
    if (self = [super init]) {
        _style = style;
        
        _tabBar = [[ESTabBar alloc] initWithStyle:_style];
        [_tabBar setTintColorR:200 g:200 b:200];
        [_tabBar setSelectedTintColorR:216 g:92 b:92];
        _tabBar.edgeInsets = UIEdgeInsetsMake(4, 15, 4, 15);
        _tabBar.spacing = 15;
        _tabBar.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakself = self;
        [_tabBar setOnClickItem:^(NSInteger idx) {
            [weakself moveToIndex:idx animated:YES];
        }];
        [self addSubview:_tabBar];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
        pan.delegate = self;
        [_scrollView addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index {
    if (_index == index) {
        return;
    }
    _index = index;
    [self.delegate tabView:self didMoveToIndex:index];
}



- (void)setItemsWithViews:(NSArray<__kindof UIView *> *)views titles:(NSArray<NSString *> *)titles index:(NSInteger)index {
    _index = -1;
    self.index = index;
    _views = [views copy];
    [_tabBar setTitles:titles];
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
    self.index = index;
    [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width * index, 0) animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _tabBar.contentOffset = scrollView.contentOffset.x / scrollView.bounds.size.width;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    self.index = (NSInteger)scrollView.contentOffset.x / scrollView.bounds.size.width;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; {
    self.index = (NSInteger)scrollView.contentOffset.x / scrollView.bounds.size.width;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat translationX = [gestureRecognizer translationInView:_scrollView].x;
    if (_scrollView.contentOffset.x == 0 && translationX > 0) {
        _scrollView.scrollEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scrollView.scrollEnabled = YES;
        });
    }
    return NO;
}


#pragma mark - Get

- (NSInteger)currentIndex {
    return _index;
}

- (UIView *)currentContentView {
    return _views[_index];
}



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




@end