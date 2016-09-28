//
//  KDFMyTabBarController.m
//  jiankangmeishi
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFMyTabBarController.h"
#import "KDFFirstTableViewController.h"
#import "KDFThirdTableViewController.h"
#import "KDFDrawViewController.h"
#import "KDFSecondCollectionViewController.h"

@interface KDFMyTabBarController ()

@end

@implementation KDFMyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
#pragma mark--视图创建
- (void)configUI{
    UINavigationController *_fvc = [[UINavigationController alloc]initWithRootViewController:[KDFFirstTableViewController new]];
    _fvc.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"最新" image:[[UIImage imageNamed:@"first1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:nil];
    //设置字体的大小
    [_fvc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    
    // 创建流布局
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    // 设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UINavigationController *_svc = [[UINavigationController alloc]initWithRootViewController:[[KDFSecondCollectionViewController alloc]initWithCollectionViewLayout:flowLayout]];
    //不能通过这种方式引导CollectionViewController 先要设置他的UICollectionViewFlowLayout
//      UINavigationController *_svc = [[UINavigationController alloc]initWithRootViewController:[KDFSecondCollectionViewController new]];
   
    _svc.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"分类" image:[[UIImage imageNamed:@"second2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:nil];
    //设置字体的大小
    [_svc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    
    UINavigationController *_tvc = [[UINavigationController alloc]initWithRootViewController:[KDFThirdTableViewController new]];
    _tvc.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"收藏" image:[[UIImage imageNamed:@"third3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:nil];
    //设置字体的大小
    [_tvc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    
    self.viewControllers = @[_fvc,_svc,_tvc];
    self.tabBar.barTintColor = [UIColor colorWithRed:254/255.f green:254/255.f blue:255/255.f alpha:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
