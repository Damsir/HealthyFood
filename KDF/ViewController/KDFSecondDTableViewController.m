//
//  KDFSecondDTableViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/9.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFSecondDTableViewController.h"
#import "KDFFirstService.h"
#import "KDFFirstTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "KDFFirstDDTableViewController.h"

#define identifier @"SecondDetailCell"

#import "kdf-Swift.h" //调用Switf 混编

@interface KDFSecondDTableViewController ()
{
    NSMutableArray *_resultArr;
    int _pageCount;
//    UIActivityIndicatorView *_activityView;
    WCIndicator *_indicator;
    BOOL aa;
}
@end

@implementation KDFSecondDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
}

#pragma mark -
#pragma mark 初始化UI
- (void)configUI{
    aa = YES;
    _resultArr = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"KDFFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    
//    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    _activityView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 3);
//    _activityView.color = [UIColor lightGrayColor];
//    [_activityView startAnimating];
//    _activityView.hidesWhenStopped = YES;
//    [self.view addSubview:_activityView];
    //通过Swift启动加载视图
    _indicator = [[WCIndicator alloc]initWithFrame:CGRectMake(80, 150, 200, 200)];
    _indicator._textSize = 19;
    [self.view addSubview:_indicator];
    [_indicator start:@"加载中..." image:@"cal"];
   }

#pragma mark -
#pragma mark 加载数据
- (void)loadData{
    _pageCount = 0;
     __weak KDFSecondDTableViewController *blockSelf = self;
    [[KDFFirstService new] getSecondDDataWithURL:SECOND_DETAIL_URL andID:[self.model.idnum intValue] andPage:_pageCount withComplete:^(id data) {
        if (data) {
//            if ([_activityView isAnimating]) {
//                [_activityView stopAnimating];
//            }
            if (aa) {
                [_indicator success:@"加载成功!"];
                [_indicator removeFromSuperview];
                aa = NO;
            }
            _resultArr = data;
            [blockSelf.tableView reloadData];
        }
    }];
}

#pragma mark --
#pragma mark -- 点击事件

#pragma mark -
#pragma mark 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KDFFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    KDFFirstDetailModel *model = _resultArr[indexPath.row];
    //设置Cell
    [cell.TitelImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    cell.titelLabel.text = model.title;
    cell.desLabel.text = model.intro;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    return cell;
}
//跳转至下一个界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KDFFirstDDTableViewController *ddvc = [KDFFirstDDTableViewController new];
    ddvc.model = _resultArr[indexPath.row];
    [self.navigationController pushViewController:ddvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
