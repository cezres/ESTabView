//
//  ESTabBar.m
//  ESTabView
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESTabBar.h"

#define ColorRGBA(r, g, b, a)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define ColorRGB(r, g, b)                   ColorRGBA((r), (g), (b), 1.0)

@interface ESTabBar ()

{
    CGFloat _cR;
    CGFloat _cG;
    CGFloat _cB;
    CGFloat _sCR;
    CGFloat _sCG;
    CGFloat _sCB;
    
    UIColor *_color;
    UIColor *_sColor;
    
    NSMutableArray<NSString *> *_titles;
    NSMutableArray<UIButton *> *_items;
    UIView *_bottomLine;
    UIView *_contentView;
}

@property (assign, nonatomic) NSInteger index;

@end

@implementation ESTabBar

- (instancetype)initWithStyle:(ESTabBarStyle)style {
    if (self = [super initWithFrame:CGRectZero]) {
        _style = style;
        if (style == ESTabBarStyleNormal) {
            [self initNormalContentView];
        }
        else {
            [self initScrollContentView];
        }
        _bottomLine = [[UIView alloc] init];
        [_contentView addSubview:_bottomLine];
        _items = [NSMutableArray array];
        
        [self setTintColorR:200 g:200 b:200];
        [self setSelectedTintColorR:34 g:34 b:34];
    }
    return self;
}

- (void)onClickItem:(UIButton *)item {
    _onClickItem ? _onClickItem(item.tag) : NULL;
}

#pragma mark - Item 

- (void)setItemTitle:(NSString *)title forIndex:(NSInteger)index {
    [_items[index] setTitle:title forState:UIControlStateNormal];
    [self setNeedsLayout];
}

#pragma mark - Set/Get Property

- (void)setContentOffset:(CGFloat)contentOffset {
    if (contentOffset < 0 || contentOffset > _items.count-1) {
        return;
    }
    NSInteger index = (NSInteger)contentOffset;
    CGFloat progress = contentOffset - index;
    
    
    /**
     *  Line Color
     */
    CGFloat lineX;
    CGFloat lineWidth;
    if (index == _items.count-1) {
        lineX = _items[index].frame.origin.x;
        lineWidth = _items[index].frame.size.width;
    }
    else {
        lineX = _items[index].frame.origin.x + (_items[index + 1].frame.origin.x - _items[index].frame.origin.x) * progress;
        lineWidth = _items[index].frame.size.width + (_items[index + 1].frame.size.width - _items[index].frame.size.width) * progress;
    }
    _bottomLine.frame = CGRectMake(lineX, _bottomLine.frame.origin.y, lineWidth, _bottomLine.bounds.size.height);
    
    /**
     *  Items Color
     */
    if (contentOffset > _index) {
        if (progress == 0) {
            [_items[index] setTitleColor:_sColor forState:UIControlStateNormal];
            [_items[index-1] setTitleColor:_color forState:UIControlStateNormal];
        }
        else {
            UIColor *color1 = ColorRGB(_sCR + (_cR - _sCR) * progress, _sCG + (_cG - _sCG) * progress, _sCB + (_cB - _sCB) * progress);
            UIColor *color2 = ColorRGB(_cR + (_sCR - _cR) * progress, _cG + (_sCG - _cG) * progress, _cB + (_sCB - _cB) * progress);
            [_items[index] setTitleColor:color1 forState:UIControlStateNormal];
            [_items[index+1] setTitleColor:color2 forState:UIControlStateNormal];
        }
        if (_index != index) {
            _index = index;
        }
    }
    else if (contentOffset < _index) {
        progress = 1 - progress;
        if (progress == 0) {
            [_items[index] setTitleColor:_sColor forState:UIControlStateNormal];
            [_items[index+1] setTitleColor:_color forState:UIControlStateNormal];
        }
        else {
            UIColor *color1 = ColorRGB(_sCR + (_cR - _sCR) * progress, _sCG + (_cG - _sCG) * progress, _sCB + (_cB - _sCB) * progress);
            UIColor *color2 = ColorRGB(_cR + (_sCR - _cR) * progress, _cG + (_sCG - _cG) * progress, _cB + (_sCB - _cB) * progress);
            [_items[index+1] setTitleColor:color1 forState:UIControlStateNormal];
            [_items[index] setTitleColor:color2 forState:UIControlStateNormal];
        }
        if (1 - progress == 0) {
            if (_index != index) {
                _index = index;
            }
        }
        else if (index+1 < _index) {
            _index = index+1;
        }
    }
    
    if (_style == ESTabBarStyleScroll) {
        UIScrollView *scrollView = (UIScrollView *)_contentView;
        [self layoutIfNeeded];
        if (scrollView.contentSize.width <= scrollView.bounds.size.width) {
            return;
        }
        scrollView.contentOffset = CGPointMake((scrollView.contentSize.width - scrollView.bounds.size.width) * (contentOffset / (_items.count-1)), 0);
    }
    
}

- (NSInteger)currentIndex {
    return _index;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _index = currentIndex;
    [self settingItemsColor];
    _contentOffset = currentIndex;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _index = -1;
    _titles = [NSMutableArray arrayWithArray:titles];
    [self createItemViews];
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:titles[idx] forState:UIControlStateNormal];
        obj.tag = idx;
    }];
    
    [self settingItemsColor];
    [self setNeedsLayout];
}

- (void)setTintColorR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    _cR = r; _cG = g; _cB = b;
    _color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    [self settingItemsColor];
}

- (void)setSelectedTintColorR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    _sCR = r; _sCG = g; _sCB = b;
    _sColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    [self settingItemsColor];
    _bottomLine.backgroundColor = _sColor;
}

- (void)setSpacing:(CGFloat)spacing {
    _spacing = spacing;
    [self setNeedsLayout];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self setNeedsLayout];
}


#pragma mark - View

- (void)initNormalContentView {
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
}
- (void)initScrollContentView {
    _contentView = [[UIScrollView alloc] init];
    ((UIScrollView *)_contentView).showsHorizontalScrollIndicator = NO;
    [self addSubview:_contentView];
}

- (void)createItemViews {
    for (NSInteger i=_items.count; i<_titles.count; i++) {
        UIButton *item = [self createItemView];
        [_contentView addSubview:item];
        [_items addObject:item];
    }
    NSInteger itemsCount = _items.count;
    for (NSInteger i=itemsCount-1; i>=_titles.count; i--) {
        [_items.lastObject removeFromSuperview];
        [_items removeLastObject];
    }
}

- (UIButton *)createItemView {
    UIButton *item = [UIButton buttonWithType:UIButtonTypeSystem];
    item.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    [item addTarget:self action:@selector(onClickItem:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = CGRectMake(_edgeInsets.left,
                                    _edgeInsets.top,
                                    self.bounds.size.width - _edgeInsets.left - _edgeInsets.right,
                                    self.bounds.size.height - _edgeInsets.top - _edgeInsets.bottom);
    [self layoutItems];
    if (_index >= 0) {
        _bottomLine.frame = CGRectMake(_items[_index].frame.origin.x, _contentView.bounds.size.height-2, _items[_index].frame.size.width, 2);
    }
}

- (void)layoutItems {
    if (_style == ESTabBarStyleNormal) {
        CGFloat itemWidth = (_contentView.bounds.size.width - _spacing * (_items.count-1)) / _items.count;
        [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake((itemWidth + _spacing) * idx, 0, itemWidth, _contentView.bounds.size.height);
        }];
    }
    else {
        __block CGFloat x = 0;
        [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleForState:UIControlStateNormal];
            CGFloat width = [title boundingRectWithSize:CGSizeMake(999, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: obj.titleLabel.font} context:NULL].size.width;
            obj.frame = CGRectMake(x, 0, width, _contentView.bounds.size.height);
            x += width + self.spacing;
        }];
        ((UIScrollView *)_contentView).contentSize = CGSizeMake(x-_spacing, 0);
    }
}


- (void)settingItemsColor {
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == _index) {
            [obj setTitleColor:[UIColor colorWithRed:_sCR/255.0 green:_sCG/255.0 blue:_sCB/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else {
            [obj setTitleColor:[UIColor colorWithRed:_cR/255.0 green:_cG/255.0 blue:_cB/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }];
}

@end
