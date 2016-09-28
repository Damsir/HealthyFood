//
//  KDFFirstTableViewController.m
//  jiankangmeishi
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFFirstTableViewController.h"
#import "KDFDrawViewController.h"
#import "KDFFirstService.h"
#import "KDFFirstTableViewCell.h"
#import "KDFFirstModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "KDFFirstDetailTableViewController.h"
#import "ADScrollView.h"
#define identifier @"firstCell"

#import "kdf-Swift.h" //调用Switf 混编

@interface KDFFirstTableViewController ()
{
    NSMutableArray *_resultArr;            //存放请求的网络数据
//    UIActivityIndicatorView * activityView;//菊花
    int _curentPage;                      //加载的页面数
    KDFDrawViewController * dvc;         //父控制器(抽屉控制器)
    UITapGestureRecognizer *tapGesture;  //记录点击手势pan
    BOOL _haveTap;                      //记录点击手势pan是否添加
    UIView *_ADView;                    //广告栏视图
    ADScrollView *_adScrollView;
    WCIndicator *_indicator;
    BOOL aa;
   }

@end

@implementation KDFFirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    [self loadData];
    [self loadADdata];
}
- (void) configUI{
    _haveTap = NO;
    aa = YES;
    //如果在loadData中初始化_resultArr 会导致上拉刷新加载时出错
    _resultArr = [NSMutableArray new];
   self.navigationItem.title = @"最新类表";
    // 创建加载视图
//        activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        activityView.center = CGPointMake(SCREEN_WIDTH / 2, 260);
//        [self.view addSubview:activityView];
//        // 设置颜色
//        [activityView startAnimating];
//        activityView.hidesWhenStopped = YES;
//        activityView.color = [UIColor blackColor];
 
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KDFFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    //head刷新
    __weak KDFFirstTableViewController *blockSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockSelf loadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([blockSelf.tableView.header isRefreshing]) {
                [blockSelf.tableView.header endRefreshing];
            }
        });
    }];
    //foot刷新
    // footer 刷新
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [blockSelf loadMoreData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([blockSelf.tableView.footer isRefreshing]) {
                [blockSelf.tableView.footer endRefreshing];
            }
        });
    }];
    
    dvc =(KDFDrawViewController *)self.navigationController.tabBarController.parentViewController;
    
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    //广告栏的设置
    _ADView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    _adScrollView = [[ADScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 195)];
    [_ADView addSubview:_adScrollView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 40)];
    [_ADView addSubview:label];
    label.text = @"不一样的美食，不一样的味道！";
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = _ADView;
    
    //通过Swift启动加载视图
    _indicator = [[WCIndicator alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 230, 100, 100)];
    _indicator._textSize = 19;
    [self.view addSubview:_indicator];
    [_indicator start:@"加载中..." image:@"cal"];
}
#pragma mark--加载数据
- (void)loadADdata{
    NSString *str1 = @"http://api.shs.hzsheteng.com:9005/recipe/07_29/1409800105178.jpg";
    NSString *str2 = @"http://api.shs.hzsheteng.com:9005/recipe/11_23/1409795904663.jpg";
    NSString *str3 = @"http://api.shs.hzsheteng.com:9005/recipe/05_23/1409739703225.jpg";
    NSString *str4 =@"http://api.shs.hzsheteng.com:9005/recipe/09_11/1409739822241.jpg";
    NSString *str5 = @"http://api.shs.hzsheteng.com:9005/recipe/04_14/1409739824975.jpg";
    _adScrollView.imageArr = @[str1,str2,str3,str4,str5];
    [_adScrollView reloadData];
}
- (void)loadData{
    _curentPage = 0;
    __weak KDFFirstTableViewController *blockSelf = self;
    [[KDFFirstService new] getFirstDataWithURL:FIRST_LIST_URL andPage:_curentPage withComplete:^(id data) {
        if (data) {
            
            //让启动加载视图消失
            if (aa) {
                [_indicator success:@"加载成功!"];
                [_indicator removeFromSuperview];
                aa = NO;
            }


            if ([blockSelf.tableView.header isRefreshing]) {
                [blockSelf.tableView.header endRefreshing];
            }
           _resultArr = data;
            [blockSelf.tableView reloadData];

        }
    }];
}

- (void)loadMoreData{
    _curentPage++;
    [[KDFFirstService new] getFirstDataWithURL:FIRST_LIST_URL andPage:_curentPage withComplete:^(id data) {
        if (data) {
            if ([self.tableView.header isRefreshing]) {
                [self.tableView.header endRefreshing];
            }
            if ([self.tableView.footer isRefreshing]) {
                [self.tableView.footer endRefreshing];
            }
            if (_resultArr) {
                //从数组中获得数据并添加到可变数组中
                [_resultArr addObjectsFromArray:data];
                [self.tableView reloadData];
            }
        }
    }];

}
#pragma mark--点击事件
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KDFFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath ];
    KDFFirstModel *model = [_resultArr objectAtIndex:indexPath.row];
    [cell.TitelImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    cell.titelLabel.text = model.title;
    cell.desLabel.text = model.content;
//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    return cell;
}
//跳转至下一个界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KDFFirstDetailTableViewController *fdvc = [KDFFirstDetailTableViewController new];
    fdvc.model = _resultArr[indexPath.row];
    fdvc.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:fdvc animated:YES];
}
@end
