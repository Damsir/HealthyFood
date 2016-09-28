//
//  KDFThirdTableViewController.m
//  jiankangmeishi
//
//  Created by qianfeng on 16/1/6.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFThirdTableViewController.h"
#import "KDFDrawViewController.h"
#import "KDFDetailDAO.h"
#import "KDFFirstTableViewCell.h"
#import "KDFDAOModel.h"
#import "UIImageView+WebCache.h"
#import "KDFThirdDetailTableViewController.h"

#define identifier @"DAOcell"
@interface KDFThirdTableViewController ()
{
    NSMutableArray *_modelArr;
    NSMutableArray *deleteArr;
    KDFDrawViewController * dvc;         //父控制器(抽屉控制器)
    UITapGestureRecognizer *tapGesture;  //记录点击手势pan
    BOOL _haveTap;                       //记录点击手势pan是否添加
    UIButton *btn;
}
@end

@implementation KDFThirdTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [self loadData];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
//    [self loadData];
}
- (void) configUI{
    deleteArr = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mapbg"]];
    self.navigationItem.title = @"收藏类表";

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor orangeColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KDFFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
//    //右边设置编辑按钮
    btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
    
    dvc =(KDFDrawViewController *)self.navigationController.tabBarController.parentViewController;
    //手势添加
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    

}

- (void)loadData{
    _modelArr = [[[KDFDetailDAO new] findAllContacts] mutableCopy];
    if (_modelArr.count == 0) {
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收藏类表为空,请先收藏!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [view show];
    }
    [self.tableView reloadData];
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
- (IBAction)rightBtnClicked:(id)sender{
// 设置tabview能否编辑
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing == YES) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"编辑" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-代理方法
#pragma mark - Table view data source
// 返回编辑模式的样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KDFFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    KDFDAOModel *model = _modelArr[indexPath.row];
    cell.titelLabel.text = model.titel;
    [cell.TitelImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    cell.desLabel.text = model.intro;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mapbg"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
            KDFThirdDetailTableViewController *tdvc = [KDFThirdDetailTableViewController new];
            tdvc.model = _modelArr[indexPath.row];
            [self.navigationController pushViewController:tdvc animated:YES];
        
}
// 设置每个row能否编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //将要删除的model
        [deleteArr addObject:_modelArr[indexPath.row]];
        
        [_modelArr removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    for (KDFDAOModel *model in deleteArr) {
        //从数据库中删除一个model
        [[KDFDetailDAO new] deleteContact:model.titel];
    }
}
@end
