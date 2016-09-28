//
//  KDFSousuoViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/15.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFSousuoViewController.h"

@interface KDFSousuoViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation KDFSousuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
- (void)configUI{
    self.title = @"搜索";
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    // 创建NSURL
    NSURL * url = [NSURL URLWithString:@"http://www.baidu.com"];
    // 创建一个Request
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.color = [UIColor blackColor];
    [_indicatorView startAnimating];
    _indicatorView.hidesWhenStopped = YES;
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:_indicatorView];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([_indicatorView isAnimating]) {
        [_indicatorView stopAnimating];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
