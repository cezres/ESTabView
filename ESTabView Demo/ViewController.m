//
//  ViewController.m
//  ESTabView Demo
//
//  Created by 翟泉 on 2016/8/10.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ViewController.h"
#import "ESTabView.h"

@interface ViewController ()
<UIScrollViewDelegate, ESTabViewDelegate>
{
    ESTabBar *_tabbar;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:UIView.new];
    
    self.view.backgroundColor = [UIColor colorWithWhite:247/255.0 alpha:1.0];
    
    ESTabView *tabView = [[ESTabView alloc] initWithStyle:ESTabBarStyleScroll];
    tabView.delegate = self;
    NSArray *titles = @[@"测试", @"测试", @"测试测试", @"测试111测试", @"测试测试测试12123", @"测试测试"];
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSInteger i=0; i<titles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        [views addObject:view];
    }
    [tabView setItemsWithViews:views titles:titles index:1];
    
    tabView.frame = CGRectMake(20, 100, self.view.bounds.size.width-40, 400);
    
    [self.view addSubview:tabView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *titles = @[@"测试", @"测试", @"测试测试", @"测试111测试"];
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:titles.count];
        for (NSInteger i=0; i<titles.count; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
            [views addObject:view];
        }
        [tabView setItemsWithViews:views titles:titles index:1];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tabView moveToIndex:4 animated:YES];
//    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tabView setItemTitle:@"XXX" forIndex:4];
//    });
    
}

- (void)tabView:(ESTabView *)tabView didMoveToIndex:(NSInteger)index {
    NSLog(@"%s %ld", __FUNCTION__, index);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _tabbar.contentOffset = scrollView.contentOffset.x / scrollView.bounds.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
