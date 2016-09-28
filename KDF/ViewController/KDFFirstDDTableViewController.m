//
//  KDFFirstDDTableViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFFirstDDTableViewController.h"
#import "KDFFirstService.h"
#import "KDFfirstDDDModel.h"
#import "KDFFirstDDModel.h"
#import "UIImageView+WebCache.h"
#import "KDFFDTableViewCell.h"
#import "KDFDetailDAO.h"
#import "KDFDAOModel.h"

#define Identifier @"myFDCell"

@interface KDFFirstDDTableViewController ()
{
    KDFFirstDDModel * _myModel;
    UIView *_view;
    BOOL _isExit;
}
@end

@implementation KDFFirstDDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark --
#pragma mark -- 视图初始化
- (void)configUI{
    _isExit = NO;
//    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle: style:UIBarButtonItemStylePlain target:self action:@selector(rigthBarButtonClicked:)];
    
//自定义rightBarButtonItem
   UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitle:@"收藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
       //构建headView
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 380)];
    _view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.model.cover] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    [_view addSubview:imageview];

    UILabel *_titelLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 185, SCREEN_WIDTH-10, 20)];
    _titelLabel.text = self.model.title;
    _titelLabel.font = [UIFont boldSystemFontOfSize:16];
    [_view addSubview:_titelLabel];
    
    UILabel *_desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, SCREEN_WIDTH-10, 110)];
    _desLabel.text = self.model.intro;
    _desLabel.numberOfLines = 0;
    _desLabel.font = [UIFont boldSystemFontOfSize:11];
    [_view addSubview:_desLabel];
    
    UILabel *labelone = [[UILabel alloc]initWithFrame:CGRectMake(10, 325, 60, 20)];
    labelone.text = @"制作时间:";
    labelone.font = [UIFont boldSystemFontOfSize:11];
    [_view addSubview:labelone];
  
    UILabel *labeltwo = [[UILabel alloc]initWithFrame:CGRectMake(10, 350, 60, 20)];
    labeltwo.text = @"用餐人数:";
    labeltwo.font = [UIFont boldSystemFontOfSize:11];
    [_view addSubview:labeltwo];
    
    
    self.tableView.tableHeaderView =_view;
    
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"KDFFDTableViewCell" bundle:nil] forCellReuseIdentifier:Identifier];
}

#pragma mark --
#pragma mark -- 数据加载
- (void)loadData{
    [[KDFFirstService new] getFirstDDDatawithURL:FIRST_DDETAIL_LIST_URL andID:[self.model.idnum intValue] withComplete:^(id data) {
        if (data) {
            _myModel = data;
            
            UILabel *labeloneone = [[UILabel alloc]initWithFrame:CGRectMake(80, 325, SCREEN_WIDTH-80, 20)];
            labeloneone.text = _myModel.maketime;
            labeloneone.font = [UIFont boldSystemFontOfSize:11];
            [_view addSubview:labeloneone];
            
            UILabel *labeltwotwo = [[UILabel alloc]initWithFrame:CGRectMake(80, 350, SCREEN_WIDTH-80, 20)];
            labeltwotwo.text = _myModel.numofpeople;
            labeltwotwo.font = [UIFont boldSystemFontOfSize:11];
            [_view addSubview:labeltwotwo];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark --
#pragma mark -- 点击事件
//收藏功能的实现
- (IBAction)btnClicked:(id)sender{
 //model.title  model.intro model.cover  model.idnum
    KDFDAOModel *model = [KDFDAOModel new];
    model.titel = self.model.title;
    model.intro = self.model.intro;
    model.cover = self.model.cover;
    model.idnum = self.model.idnum;
    //如果存在就不收藏
    NSArray *resultArr = [NSArray new];
    KDFDetailDAO *DAO = [KDFDetailDAO new];
    resultArr = [DAO findAllContacts];
    
    for (KDFDAOModel *m in resultArr) {
        if ([m.titel isEqualToString: model.titel]) {
            _isExit = YES;
            break;
        }
    }
    if (_isExit) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        _isExit = NO;
    }else{
        if ([DAO saveContact:model]) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"收藏成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"收藏失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
   }
#pragma mark --
#pragma mark -- 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 24)];
        label.text = @"制作步骤:";
        [view addSubview:label];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myModel.DetailArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KDFFDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    KDFfirstDDDModel *ddModel = _myModel.DetailArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];

    [cell.titelImage sd_setImageWithURL:[NSURL URLWithString:ddModel.img] placeholderImage:[UIImage imageNamed:@"soul"]];
    cell.desLabel.text = ddModel.desc;
    cell.desLabel.font = [UIFont boldSystemFontOfSize:12];
    return cell;
}

@end
