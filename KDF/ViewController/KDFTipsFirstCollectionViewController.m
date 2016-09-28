//
//  KDFTipsFirstCollectionViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/12.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFTipsFirstCollectionViewController.h"
#import "KDFTipsCollectionViewCell.h"
#import "KDFFirstService.h"
#import "KDFTipsModel.h"
#import "UIImageView+WebCache.h"
#import "KDFTipsScondViewController.h"

@interface KDFTipsFirstCollectionViewController ()
{
    NSArray *_tipArr;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation KDFTipsFirstCollectionViewController

static NSString * const reuseIdentifier = @"tipsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)configUI{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    [btn addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    self.navigationItem.title = @"厨房宝典";
    
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"secondbg"]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"KDFTipsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2 );
    _activityView.color = [UIColor darkGrayColor];
    [_activityView startAnimating];
    _activityView.hidesWhenStopped = YES;
    [self.collectionView addSubview:_activityView];
}
- (void)loadData{
    [[KDFFirstService new] getTipDataWithComplete:^(id data) {
        if (data) {
            if ([_activityView isAnimating]) {
                [_activityView stopAnimating];
            }
             _tipArr = data;
            [self.collectionView reloadData];
        }
    }];
}
- (IBAction)btnBackClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--
#pragma mark-- 代理方法
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tipArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KDFTipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    KDFTipsModel *model = _tipArr[indexPath.row];
    //设置cell图片
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"foodbg"]];
    cell.titleLabel.text = model.title;
    cell.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.titleLabel.numberOfLines = 0;
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backImage"]];
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
//跳转到下一界面
    KDFTipsScondViewController *_tsvc = [KDFTipsScondViewController new];
    _tsvc.tipModel = _tipArr[indexPath.row];
    [self.navigationController pushViewController:_tsvc animated:YES];
}

@end
