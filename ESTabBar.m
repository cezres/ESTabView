//
//  ESTabBar.m
//  TabbarDemo
//
//  Created by 翟泉 on 16/3/21.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESTabBar.h"

@interface ESTabBar ()
{
    CGSize _size;
}

@property (strong, nonatomic) NSMutableArray<UIButton *> *buttons;
@property (strong, nonatomic) NSMutableArray<NSString *> *titles;

@end

@implementation ESTabBar

- (instancetype)initWithFrame:(CGRect)frame; {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        self.titles = [NSMutableArray array];
        self.buttons = [NSMutableArray array];
    }
    return self;
}
- (instancetype)init; {
    if (self = [super init]) {
        self.showsHorizontalScrollIndicator = NO;
        self.titles = [NSMutableArray array];
        self.buttons = [NSMutableArray array];
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex; {
    
    if (selectedIndex >= self.buttons.count) {
        return;
    }
    
    [self.tabbarDelegate tabbar:self selectedIndex:selectedIndex];
    
    _selectedIndex = selectedIndex;
    
    
    
    NSInteger moveIndex = selectedIndex;
    if (self.buttons[selectedIndex].center.x - self.contentOffset.x > self.frame.size.width/2) {
        if (moveIndex+2 < self.buttons.count)
            moveIndex += 2;
        else if (moveIndex+1 < self.buttons.count)
            moveIndex += 1;
    }
    else {
        if (moveIndex-2 >= 0)
            moveIndex -= 2;
        else if (moveIndex-1 >= 0)
            moveIndex -= 1;
    }
    [self scrollRectToVisible:self.buttons[moveIndex].frame animated:YES];
    
    
    CGFloat width = [self.buttons[_selectedIndex].titleLabel.text boundingRectWithSize:CGSizeMake(99999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.buttons[_selectedIndex].titleLabel.font} context:NULL].size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.line.frame = CGRectMake(self.buttons[_selectedIndex].frame.origin.x + (self.buttons[_selectedIndex].frame.size.width - width)/2, self.frame.size.height-2, width, 2);
    }];
}

- (void)selectedItem:(UIButton *)button; {
    self.selectedIndex = button.tag;
}

- (void)setTabWithTitles:(NSArray<NSString *> *)titles; {
    [self.titles removeAllObjects];
    [self.titles addObjectsFromArray:titles];
    
    NSInteger count = self.buttons.count;
    for (NSInteger i=count; i<titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
        [button addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    count = self.buttons.count;
    for (NSInteger i=count-1; i>=self.titles.count; i--) {
        [self.buttons[i] removeFromSuperview];
        [self.buttons removeLastObject];
    }
    
    [self setUpTitle];
    
    _size = CGSizeZero;
    [self setNeedsLayout];
}
- (void)insertTabWithTitle:(NSString *)title atIndex:(NSUInteger)index; {
    [self.titles insertObject:title atIndex:index];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    [button addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self.buttons insertObject:button atIndex:index];
    
    [self setUpTitle];
    
    _size = CGSizeZero;
    [self setNeedsLayout];
}
- (void)removeTabAtIndex:(NSUInteger)index; {
    [self.titles removeObjectAtIndex:index];
    [self.buttons[index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
    
    _size = CGSizeZero;
    [self setNeedsLayout];
}
- (void)setTitle:(NSString *)title forItemAtIndex:(NSUInteger)index; {
    [self.titles replaceObjectAtIndex:index withObject:title];
    [self.buttons[index] setTitle:title forState:UIControlStateNormal];
}

- (void)setUpTitle; {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTitle:self.titles[idx] forState:UIControlStateNormal];
        obj.tag = idx;
    }];
}

- (void)layoutSubviews; {
    if (CGSizeEqualToSize(self.bounds.size, _size)) {
        return;
    }
    
    _size = self.bounds.size;
    
    if (self.buttons.count > 5) {
        CGFloat x = 0;
        for (UIButton *button in _buttons) {
            CGFloat width = [button.titleLabel.text boundingRectWithSize:CGSizeMake(99999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: button.titleLabel.font} context:NULL].size.width + 40;
            button.frame = CGRectMake(x, 0, width, self.frame.size.height);
            x = button.frame.origin.x + width;
        }
        self.scrollEnabled = YES;
        self.contentSize = CGSizeMake(x, self.frame.size.height);
    }
    else if (_buttons.count > 0) {
        CGFloat itemWidth = self.frame.size.width / _buttons.count;
        for (int i=0; i<_buttons.count; i++) {
            _buttons[i].frame = CGRectMake(itemWidth*i, 0, itemWidth, self.frame.size.height);
        }
        self.contentOffset = CGPointZero;
        self.scrollEnabled = NO;
    }
    
    if (_selectedIndex >= _buttons.count) {
        self.selectedIndex = _buttons.count-1;
    }
    
    CGFloat width = [_buttons[_selectedIndex].titleLabel.text boundingRectWithSize:CGSizeMake(9999, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _buttons[_selectedIndex].titleLabel.font} context:NULL].size.width;
    self.line.frame = CGRectMake(_buttons[_selectedIndex].frame.origin.x + (_buttons[_selectedIndex].frame.size.width - width)/2, self.frame.size.height-2, width, 2);
    
    
    [super layoutSubviews];
}

- (UIView *)line; {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:217/255.0 green:92/255.0 blue:92/255.0 alpha:1.0];
        [self addSubview:_line];
    }
    return _line;
}

@end
