//
//  KDFTipsScondViewController.m
//  KDF
//
//  Created by qianfeng on 16/1/12.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFTipsScondViewController.h"
//#import "UMSocial.h"

@interface KDFTipsScondViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *_indicatorView;
}
@end

@implementation KDFTipsScondViewController

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
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:webView];
    webView.delegate = self;
    [webView loadHTMLString:self.tipModel.content baseURL:nil];
    _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.color = [UIColor blackColor];
    [_indicatorView startAnimating];
    _indicatorView.hidesWhenStopped = YES;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:_indicatorView];
    self.navigationItem.rightBarButtonItem = btnItem;
   }

#pragma mark -
#pragma mark 加载数据

#pragma mark -
#pragma mark 事件
/**
 * 分享实现
 */
//- (IBAction)btnClicked:(id)sender{
////    http://gsapi.hhcng.com:9005/topic/view?id=21
//   NSString *str = [NSString stringWithFormat:@"%@%@",@"http://gsapi.hhcng.com:9005/topic/view?id=",self.tipModel.idnum];
//
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
//    [UMSocialData defaultData].extConfig.qqData.url = str;
//    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"5618d24ee0f55aefc20014ca"
//                                      shareText:@"健康美食"
//                                     shareImage:[UIImage imageNamed:@"foodbg"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToYXSession,nil]
//                                       delegate:nil];
//    
//}

#pragma mark -
#pragma mark 数据请求

#pragma mark -
#pragma mark 代理
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([_indicatorView isAnimating]) {
        [_indicatorView stopAnimating];
    }
    //自定义rightBarButtonItem
//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
//    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    [btn setTitle:@"分享" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark -
#pragma mark 业务逻辑

#pragma mark -
#pragma mark 通知注册和销毁
@end
