//
//  KDFFirstDetailTableViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFFirstDetailTableViewController.h"
#import "KDFFirstDetailModel.h"
#import "KDFFirstService.h"
#import "KDFFirstTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "KDFFirstDDTableViewController.h"

#define indentifier @"detailCell"

#import "kdf-Swift.h" //调用Switf 混编

@interface KDFFirstDetailTableViewController ()
{
    NSMutableArray *_resultArr;
//    UIActivityIndicatorView *_activityView;
    WCIndicator *_indicator;
    BOOL aa;
}

@end

@implementation KDFFirstDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];

}
- (void)configUI{
    aa = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    _resultArr = [NSMutableArray new];
    [self.tableView registerNib:[UINib nibWithNibName:@"KDFFirstTableViewCell" bundle:nil] forCellReuseIdentifier:indentifier];
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

- (void)loadData{
    __weak KDFFirstDetailTableViewController *blockSelf = self;
    [[KDFFirstService new] getFirstDetailDataWithURL:FIRST_DETAIL_LIST_URL andID:[self.model.idnum intValue] withComplete:^(id data) {
        if (data) {
            //让启动加载视图消失
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resultArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KDFFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    KDFFirstDetailModel *model = _resultArr[indexPath.row];
    [cell.TitelImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    cell.titelLabel.text = model.title;
    cell.desLabel.text = model.intro;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    return cell;
    
}
//跳转到下一个界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KDFFirstDDTableViewController *ddvc = [KDFFirstDDTableViewController new];
    ddvc.model = _resultArr[indexPath.row];
    [self.navigationController pushViewController:ddvc animated:YES];
}

@end
