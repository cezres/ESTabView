//
//  ViewController.m
//  ESTabViewDemo
//
//  Created by 翟泉 on 16/3/24.
//  Copyright © 2016年 云之彼端. All rights reserved.
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
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UIView *view5 = [[UIView alloc] init];
    view5.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UIView *view6 = [[UIView alloc] init];
    view6.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    UIView *view7 = [[UIView alloc] init];
    view7.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    
    
    ESTabView *tabView = [[ESTabView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 300)];
    tabView.delegate = self;
    [tabView setItemsWithViews:@[view1, view2, view3] titles:@[@"推荐", @"轻奢潮牌", @"设计师"]];
    [self.view addSubview:tabView];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tabView removeItemAtIndex:2];
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabView insertItemWithView:view4 title:@"AZUSA0" atIndex:3];
        [tabView insertItemWithView:view5 title:@"AZUSA1" atIndex:4];
        [tabView insertItemWithView:view6 title:@"AZUSA2" atIndex:5];
    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tabView setTitle:@"MISAKA" forItemAtIndex:0];
//        [tabView setView:view7 forItemAtIndex:0];
//    });
    
    
}

#pragma mark - ESTabViewDelegate
- (void)tabView:(ESTabView *)tabView didMoveToIndex:(NSInteger)index; {
    NSLog(@"%s:%ld", __FUNCTION__, index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
