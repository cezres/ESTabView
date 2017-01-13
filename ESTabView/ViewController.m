//
//  ViewController.m
//  ESTabView
//
//  Created by 翟泉 on 2017/1/13.
//  Copyright © 2017年 翟泉. All rights reserved.
//

#import "ViewController.h"
#import "ESTabView.h"

@interface ViewController ()
<ESTabViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ESTabView *tabView = [[ESTabView alloc] init];
    tabView.frame = CGRectMake(10, 20, self.view.bounds.size.width - 20, self.view.bounds.size.height - 30);
    tabView.backgroundColor = [UIColor orangeColor];
    tabView.delegate = self;
    [self.view addSubview:tabView];
    
    NSArray *titles = @[@"测试", @"测试", @"测试测试", @"测试111测试"];
    NSMutableArray *views = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSInteger i=0; i<titles.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        [views addObject:view];
    }
    [tabView setItemsWithViews:views titles:titles index:0];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *titles = @[@"测试", @"测试", @"测试测试", @"测试111测试", @"测试", @"测试", @"测试测试", @"测试111测试"];
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:titles.count];
        for (NSInteger i=0; i<titles.count; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
            [views addObject:view];
        }
        [tabView setItemsWithViews:views titles:titles index:0];
    });
    
}

#pragma mark - ESTabViewDelegate
- (void)tabView:(ESTabView *)tabView willDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index {
    NSLog(@"willDisplayIndex: %ld", index);
}
- (void)tabView:(ESTabView *)tabView willEndDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index {
    NSLog(@"willEndDisplayIndex: %ld", index);
}
- (void)tabView:(ESTabView *)tabView didDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index {
    NSLog(@"didDisplayIndex: %ld", index);
}
- (void)tabView:(ESTabView *)tabView didEndDisplayView:(__kindof UIView *)view forItemIndex:(NSInteger)index {
    NSLog(@"didEndDisplayIndex: %ld", index);
}



@end
