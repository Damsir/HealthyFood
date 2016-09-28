//
//  KDFGuanYuTableViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/19.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFGuanYuTableViewController.h"
#import "KDFGuanYuTableViewCell.h"
#import <MessageUI/MessageUI.h>

#define identifier  @"GuanYuCell"

@interface KDFGuanYuTableViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property(nonatomic ,strong)UIWebView *webView;
@end

@implementation KDFGuanYuTableViewController

- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc]init];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -
#pragma mark 初始化UI
- (void)configUI{
    
    self.title = @"关于";
    UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3)];
    imageView.image = [UIImage imageNamed:@"homebg"];
    self.tableView.tableHeaderView = imageView;
    [self.tableView registerNib:[UINib nibWithNibName:@"KDFGuanYuTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
}

#pragma mark -
#pragma mark 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KDFGuanYuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titelLabel.text = @"客服电话";
        cell.numLabel.text = @"18171274783";
        return cell;
    }
    if (indexPath.row == 1) {
        cell.titelLabel.text = @"短息发送";
        cell.numLabel.text = @"18171274783";
        return cell;
    }
    if (indexPath.row == 2) {
        cell.titelLabel.text = @"邮件发送";
        cell.numLabel.text = @"619917264@qq.com";
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 去除选中时的背景
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
       [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://18171274783"]]];
    }
    if (indexPath.row == 1) {
        if (![MFMessageComposeViewController canSendText]) return;
        MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc]init];
        //        vc.body = @"欢迎您的建议。。";
        vc.recipients = @[@"18171274783"];
        vc.messageComposeDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
        if (![MFMailComposeViewController canSendMail]) return ;
        MFMailComposeViewController *vc = [[MFMailComposeViewController alloc]init];
        [vc setToRecipients:@[@"619917264@qq.com"]];
        vc.mailComposeDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark--message的代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark--mail的代理方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
