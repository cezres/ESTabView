//
//  ESTabBar.m
//  ESTabView
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESTabBar.h"

@interface ESTabBar ()

{
    CGFloat _cR;
    CGFloat _cG;
    CGFloat _cB;
    CGFloat _sCR;
    CGFloat _sCG;
    CGFloat _sCB;
    
    
    NSMutableArray<NSString *> *_titles;
    NSMutableArray<UIButton *> *_items;
    UIView *_lineView;
    UIScrollView *_contentView;
}

@property (assign, nonatomic) NSInteger index;

@end

@implementation ESTabBar

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentView];
        
        _lineView = [[UIView alloc] init];
        [_contentView addSubview:_lineView];
        _items = [NSMutableArray array];

        self.color = [UIColor colorWithWhite:200/255.0 alpha:1.0];
        self.selectedColor = [UIColor colorWithWhite:34/255.0 alpha:1.0];
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
    _lineView.frame = CGRectMake(lineX, _lineView.frame.origin.y, lineWidth, _lineView.bounds.size.height);
    
    /**
     *  Items Color
     */
    if (contentOffset > _index) {
        if (progress == 0) {
//            [_items[index] setTitleColor:self.selectedColor forState:UIControlStateNormal];
//            if (_index != -1) {
//                [_items[index-1] setTitleColor:self.color forState:UIControlStateNormal];
//            }
            [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == index) {
                    [obj setTitleColor:self.selectedColor forState:UIControlStateNormal];
                }
                else {
                    [obj setTitleColor:self.color forState:UIControlStateNormal];
                }
            }];
        }
        else {
            UIColor *color1 = [UIColor colorWithRed:_sCR + (_cR - _sCR) * progress green:_sCG + (_cG - _sCG) * progress blue:_sCB + (_cB - _sCB) * progress alpha:1.0];
            UIColor *color2 = [UIColor colorWithRed:_cR + (_sCR - _cR) * progress green:_cG + (_sCG - _cG) * progress blue:_cB + (_sCB - _cB) * progress alpha:1.0];
            [_items[index] setTitleColor:color1 forState:UIControlStateNormal];
            [_items[index+1] setTitleColor:color2 forState:UIControlStateNormal];
        }
        if (_index != index) {
            _index = index;
        }
    }
    else if (contentOffset < _index) {
        progress = 1 - progress;
        if (progress == 0 || progress == 1) {
//            [_items[index] setTitleColor:self.selectedColor forState:UIControlStateNormal];
//            [_items[index+1] setTitleColor:_color forState:UIControlStateNormal];
            [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx == index) {
                    [obj setTitleColor:self.selectedColor forState:UIControlStateNormal];
                }
                else {
                    [obj setTitleColor:self.color forState:UIControlStateNormal];
                }
            }];
        }
        else {
            UIColor *color1 = [UIColor colorWithRed:_sCR + (_cR - _sCR) * progress green:_sCG + (_cG - _sCG) * progress blue:_sCB + (_cB - _sCB) * progress alpha:1.0];
            UIColor *color2 = [UIColor colorWithRed:_cR + (_sCR - _cR) * progress green:_cG + (_sCG - _cG) * progress blue:_cB + (_sCB - _cB) * progress alpha:1.0];
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
    
    if (_contentView.contentSize.width > _contentView.bounds.size.width) {
        [self layoutIfNeeded];
        if (_contentView.contentSize.width <= _contentView.bounds.size.width) {
            return;
        }
        _contentView.contentOffset = CGPointMake((_contentView.contentSize.width - _contentView.bounds.size.width) * (contentOffset / (_items.count-1)), 0);
    }
    
}

- (NSInteger)currentIndex {
    return _index;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    self.contentOffset = currentIndex;
}

#pragma mark - Title

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


#pragma mark - Color

- (void)setColor:(UIColor *)color {
    _color = color;
    [color getRed:&_cR green:&_cG blue:&_cB alpha:NULL];
    [self settingItemsColor];
}
- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [selectedColor getRed:&_sCR green:&_sCG blue:&_sCB alpha:NULL];
    [self settingItemsColor];
    _lineView.backgroundColor = selectedColor;
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
    if (_index >= 0 && _index < _items.count) {
        _lineView.frame = CGRectMake(_items[_index].frame.origin.x, _contentView.bounds.size.height-2, _items[_index].frame.size.width, 2);
    }
}

- (void)layoutItems {
    __block CGFloat x = 0;
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [obj titleForState:UIControlStateNormal];
        CGFloat width = [title boundingRectWithSize:CGSizeMake(999, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: obj.titleLabel.font} context:NULL].size.width;
        obj.frame = CGRectMake(x, 0, width, _contentView.bounds.size.height);
        x += width + _spacing;
    }];
    
    CGFloat contentWidth = x - _spacing;
    if (contentWidth > _contentView.bounds.size.width) {
        _contentView.contentSize = CGSizeMake(contentWidth, 0);
    }
    else {
        x = (_contentView.bounds.size.width - contentWidth) / 2;
        [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *title = [obj titleForState:UIControlStateNormal];
            CGFloat width = [title boundingRectWithSize:CGSizeMake(999, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: obj.titleLabel.font} context:NULL].size.width;
            obj.frame = CGRectMake(x, 0, width, _contentView.bounds.size.height);
            x += width + _spacing;
        }];
        _contentView.contentSize = CGSizeZero;
    }
}

#pragma mark - get 


#pragma mark - help

- (void)settingItemsColor {
    [_items enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == _index) {
            [obj setTitleColor:self.selectedColor forState:UIControlStateNormal];
        }
        else {
            [obj setTitleColor:self.color forState:UIControlStateNormal];
        }
    }];
}

@end
