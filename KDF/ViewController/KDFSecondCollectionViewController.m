//
//  KDFSecondCollectionViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFSecondCollectionViewController.h"
#import "KDFDrawViewController.h"
#import "KDFSecondCollectionViewCell.h"
#import "KDFFirstService.h"
#import "KDFSecondModel.h"
#import "UIImageView+WebCache.h"
#import "KDFSecondDTableViewController.h"

#import "kdf-Swift.h" //调用Switf 混编

@interface KDFSecondCollectionViewController ()
{
    NSArray *_arr1;   //存放加载的单元格的model
    NSArray *_arr2;  //存放图片的url
    UIActivityIndicatorView *_activityView;//菊花
    KDFDrawViewController * dvc;         //父控制器(抽屉控制器)
    UITapGestureRecognizer *tapGesture;  //记录点击手势pan
    BOOL _haveTap;                       //记录点击手势pan是否添加
    BOOL aa;
    WCIndicator *_indicator;
}
@end

@implementation KDFSecondCollectionViewController

static NSString * const reuseIdentifier = @"reuseCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
   
    [self.collectionView registerNib:[UINib nibWithNibName:@"KDFSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark--
#pragma mark-- 视图初始化
- (void) configUI{
    aa = YES;
    _arr1 = [NSArray new];
    _arr2 = [NSArray new];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondbg"]];
    self.navigationItem.title = @"分类类表";
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
//    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    _activityView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2 );
//    _activityView.color = [UIColor darkGrayColor];
//    [_activityView startAnimating];
//    _activityView.hidesWhenStopped = YES;
//    [self.collectionView addSubview:_activityView];
    
    dvc =(KDFDrawViewController *)self.navigationController.tabBarController.parentViewController;
    //手势添加
  tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    
    //通过Swift启动加载视图
    _indicator = [[WCIndicator alloc]initWithFrame:CGRectMake(80, 150, 200, 200)];
    _indicator._textSize = 19;
    [self.view addSubview:_indicator];
    [_indicator start:@"加载中..." image:@"cal"];
  
}

#pragma mark--
#pragma mark-- 数据加载
- (void)loadData{
    _arr2 = @[CUNJIURL,YANGFEI,NIANYEFAN,JIAOZI,CAYING,JIAOZIXIAN,LAONIANREN,XIAFANCAI,BAOBAO,DAIKECAI,SOUSHENG,FENGXIONG];
    [[KDFFirstService new] getSecondDataWithComplete:^(id data) {
        if (data) {
            if ([_activityView isAnimating]) {
                [_activityView stopAnimating];
            }
            //让启动加载视图消失
            if (aa) {
                [_indicator success:@"加载成功!"];
                [_indicator removeFromSuperview];
                aa = NO;
            }
            _arr1 = data;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark--
#pragma mark-- 点击事件
-(IBAction)leftBarButtonItemClicked:(id)sender{
    //    KDFDrawViewController * dvc = (KDFDrawViewController *)self.navigationController.tabBarController.parentViewController;
    [dvc clickDrawerButton];
    if (dvc.isDrawOpen == YES) {
        [self.view addGestureRecognizer:tapGesture];
        NSLog(@"打开了");
        _haveTap = YES;
        
    }else{
        if (_haveTap == YES) {
            [self.view removeGestureRecognizer:tapGesture];
            NSLog(@"关闭了");
            _haveTap = NO;
        }
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)recognizer{
    
    [dvc clickDrawerButton];
    if (dvc.isDrawOpen == YES) {
        NSLog(@"打开 添加");
        [self.view addGestureRecognizer:tapGesture];
        _haveTap = YES;
    }
    else{
        if (_haveTap == YES) {
            NSLog(@"关闭 移除");
            [self.view removeGestureRecognizer:tapGesture];
            _haveTap = NO;
        }
    }
    
}

#pragma mark--
#pragma mark-- 代理方法
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _arr1.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KDFSecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    KDFSecondModel *model = _arr1[indexPath.row];
    //设置cell图片
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_arr2[indexPath.row]] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    cell.label.text = model.colName;
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 40)/3, (SCREEN_WIDTH - 40)/3 + 20);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(40, 10, 20, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
// 选中某一个单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"选中%ld的section的%ld个单元格", indexPath.section, indexPath.row);
   //跳转到下一个界面
    KDFSecondDTableViewController *svc = [KDFSecondDTableViewController new];
    svc.model = _arr1[indexPath.row];
    svc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:svc animated:YES];
}

@end
