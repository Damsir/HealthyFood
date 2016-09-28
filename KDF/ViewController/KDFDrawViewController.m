//
//  KDFDrawViewController.m
//  jiankangmeishi
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFDrawViewController.h"
#import "KDFMyTabBarController.h"
#import "KDFSZTableViewController.h"
#import "KDFTipsFirstCollectionViewController.h"
#import "KDFMapViewController.h"
#import "KDFSousuoViewController.h"
#import "KDFGuanYuTableViewController.h"

#define PATH @"imagePath"

@interface KDFDrawViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    KDFMyTabBarController * _tabVC;
//    BOOL _isDrawOpen;
    UIPanGestureRecognizer * pan;
    UIScreenEdgePanGestureRecognizer * screenEdgePan;
    __weak IBOutlet UIButton *_btnImage;
    
}

@end

@implementation KDFDrawViewController
- (void)viewWillAppear:(BOOL)animated{
    //headImage 视图的构建
    //设置图片 问题************ 
    NSString * path = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), PATH];
    //通过路径找到图片
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    if (image) {
        [_btnImage setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }else{
        [_btnImage setImage:[[UIImage imageNamed:@"head1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    
    _btnImage.layer.cornerRadius = 50;
    _btnImage.layer.borderWidth = 0.5;
    _btnImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnImage.layer.masksToBounds = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
#pragma mark -
#pragma mark 初始化UI
-(void)configUI{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"homebg"]];
    _isDrawOpen = NO;
    _tabVC = [KDFMyTabBarController new];
    [self addChildViewController:_tabVC];
    [self.view addSubview:_tabVC.view];
    
    screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenPan:)];
    screenEdgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
    
}

-(void)screenPan:(UIScreenEdgePanGestureRecognizer *)recognizer{
    if (recognizer == screenEdgePan) {
        CGPoint point = [recognizer translationInView:self.view];
        NSLog(@"%f", point.x);
        if (point.x > SCREEN_WIDTH * 0.7) {
            
        }else{
            CGFloat scale = (point.x-0.7*SCREEN_WIDTH)*0.2 / (0.7*SCREEN_WIDTH) + 0.8;
            _tabVC.view.center = CGPointMake(SCREEN_WIDTH * 0.5 + point.x, _tabVC.view.center.y);
            _tabVC.view.transform = CGAffineTransformMakeScale(scale, scale);
        }
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (point.x > SCREEN_WIDTH / 2) {
                [UIView animateWithDuration:0.5 animations:^{
                    _tabVC.view.center = CGPointMake(SCREEN_WIDTH * 1.2, _tabVC.view.center.y);
                    _tabVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                }];
                _isDrawOpen = YES;
            }else{
                [UIView animateWithDuration:0.5 animations:^{
                    _tabVC.view.center = CGPointMake(SCREEN_WIDTH * 0.5, _tabVC.view.center.y);
                    _tabVC.view.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
        }
        
    }
}
#pragma mark -- 
#pragma mark -- 点击事件
//厨房宝典
- (IBAction)tipsBtnClicked:(id)sender {
    // 创建流布局
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    // 设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    KDFTipsFirstCollectionViewController *_tfvc = [[KDFTipsFirstCollectionViewController alloc]initWithCollectionViewLayout:flowLayout];
    _tfvc.hidesBottomBarWhenPushed = YES;
//    _tfvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:_tfvc animated:YES completion:nil];
    UIViewController *VC = [[UINavigationController alloc]initWithRootViewController:_tfvc];
    VC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:VC animated:YES completion:nil];
//    UINavigationController * selectedVC = _tabVC.selectedViewController;
//    [selectedVC pushViewController:_tfvc animated:NO];
//    [self closeDrawer];
}

//图片点击事件 跳转至设置界面
- (IBAction)btnImageClicked:(id)sender {
    KDFSZTableViewController * VC = [self.storyboard instantiateViewControllerWithIdentifier:@"KDFSZTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
//    VC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:VC animated:YES completion:nil];
    UINavigationController * selectedVC = _tabVC.selectedViewController;
    [selectedVC pushViewController:VC animated:YES];
    [self closeDrawer];

  }
//搜索按钮点击事件
- (IBAction)souSuoBtnclicked:(id)sender {
    KDFSousuoViewController *VC = [KDFSousuoViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    UINavigationController *selectedVC = _tabVC.selectedViewController;
    [selectedVC pushViewController:VC animated:YES];
    [self closeDrawer];
}
// 关于 按钮点击事件
- (IBAction)guanYuBtnClicked:(id)sender {
    KDFGuanYuTableViewController *VC = [KDFGuanYuTableViewController new];
    VC.hidesBottomBarWhenPushed = YES;
    UINavigationController *selectedVC = _tabVC.selectedViewController;
    [selectedVC pushViewController:VC animated:YES];
    [self closeDrawer];
}

//设置按钮点击
- (IBAction)SZBtnClicked:(id)sender {
    KDFSZTableViewController * VC = [self.storyboard instantiateViewControllerWithIdentifier:@"KDFSZTableViewController"];
    VC.hidesBottomBarWhenPushed = YES;
//    VC.btn.hidden =YES;
//    VC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:VC animated:YES completion:nil];
        UINavigationController * selectedVC = _tabVC.selectedViewController;
        [selectedVC pushViewController:VC animated:NO];
        [self closeDrawer];
}

//设置地图点击
- (IBAction)mapBtn:(id)sender{
    KDFMapViewController *_mvc = [KDFMapViewController new];
    _mvc.hidesBottomBarWhenPushed = YES;
    UINavigationController * selectedVC = _tabVC.selectedViewController;
    [selectedVC pushViewController:_mvc animated:NO];
    [self closeDrawer];
}
#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
-(void)clickDrawerButton{
    if (_isDrawOpen) {
        [self closeDrawer];
    }else{
        [self openDrawer];
    }
}

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理

#pragma mark -
#pragma mark 业务逻辑
-(void)closeDrawer{
    [UIView animateWithDuration:0.5 animations:^{
        _tabVC.view.center = CGPointMake(SCREEN_WIDTH * 0.5, _tabVC.view.center.y);
        _tabVC.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    _isDrawOpen = NO;
}

-(void)openDrawer{
    [UIView animateWithDuration:0.5 animations:^{
        _tabVC.view.center = CGPointMake(SCREEN_WIDTH * 1.2, _tabVC.view.center.y);
        _tabVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
    _isDrawOpen = YES;
}


#pragma mark -
#pragma mark 通知注册和销毁
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
