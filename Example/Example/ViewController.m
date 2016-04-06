//
//  ViewController.m
//  Example
//
//  Created by 翟泉 on 16/4/6.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ViewController.h"
@import ESTabView;

#define RandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]


@interface ViewController ()
<ESTabViewDelegate>

{
    ESTabView *_tabView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIView *view1         = [[UIView alloc] init];
    view1.backgroundColor = RandomColor;

    UIView *view2         = [[UIView alloc] init];
    view2.backgroundColor = RandomColor;

    UIView *view3         = [[UIView alloc] init];
    view3.backgroundColor = RandomColor;

    UIView *view4         = [[UIView alloc] init];
    view4.backgroundColor = RandomColor;

    UIView *view5         = [[UIView alloc] init];
    view5.backgroundColor = RandomColor;

    UIView *view6         = [[UIView alloc] init];
    view6.backgroundColor = RandomColor;

    UIView *view7         = [[UIView alloc] init];
    view7.backgroundColor = RandomColor;

    _tabView              = [[ESTabView alloc] init];
    _tabView.delegate     = self;
    
    [self.view addSubview:_tabView];
    
    
    [_tabView setItemsWithViews:@[view1, view2, view3] titles:@[@"推荐11", @"轻奢潮牌22", @"设计师333"]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tabView insertItemWithView:view4 title:@"AZUSA0" atIndex:3];
        [_tabView insertItemWithView:view5 title:@"AZUSA1" atIndex:4];
        [_tabView insertItemWithView:view6 title:@"AZUSA2" atIndex:5];
        [_tabView insertItemWithView:view7 title:@"AZUSA2" atIndex:6];
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_tabView removeItemAtIndex:1];
    });
    
    
}

- (void)viewWillLayoutSubviews; {
    [super viewWillLayoutSubviews];
    _tabView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64);
}

- (void)viewDidLayoutSubviews; {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - ESTabViewDelegate
- (void)tabView:(ESTabView *)tabView didMoveToIndex:(NSInteger)index; {
    NSLog(@"%ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
