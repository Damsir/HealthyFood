//
//  ADScrollView.m
//  TestADDemo
//
//  Created by wangliang on 15/12/9.
//  Copyright (c) 2015年 wangliang. All rights reserved.
//

#import "ADScrollView.h"
#import "UIImageView+AFNetworking.h"

#define VIEW_WIDTH self.bounds.size.width
#define VIEW_HEIGHT self.bounds.size.height
#define IMAGE_TIME_INTERVAL 3

@interface ADScrollView()<UIScrollViewDelegate>{
    UIImageView * _leftImageView; // 左视图
    UIImageView * _centerImageView; // 中间视图
    UIImageView * _rightImageView; // 右视图
    NSInteger _currentImageIndex; // 当前显示的图片序号
    UIPageControl * _pageControl; // 不解释
    NSTimer * _timer; // 自动滚动
    BOOL isAutoScroll; // 是否自动滚动
}
@end

@implementation ADScrollView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame])
    {
        [self createImageView];
    }
    return self;
}

-(void)createImageView{
    _currentImageIndex = 0;
    // 创建ImageView并设置位置
    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [self addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_WIDTH, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [self addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_WIDTH * 2, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [self addSubview:_rightImageView];
    self.contentSize = CGSizeMake(VIEW_WIDTH * 3, VIEW_HEIGHT);
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.contentOffset = CGPointMake(VIEW_WIDTH, 0);
    self.delegate = self;
}

-(void)createPageControl{
    // 一个点一般大小为20 * 20
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((VIEW_WIDTH - 20 * _imageArr.count) / 2 + self.frame.origin.x , VIEW_HEIGHT - 20 + self.frame.origin.y, 20 * _imageArr.count, 20)];
    _pageControl.numberOfPages = _imageArr.count;
    _pageControl.currentPage = _currentImageIndex;
    _pageControl.userInteractionEnabled = NO;
    // 判断是否已经添加到父视图，如果未添加，则抛出异常，由于此异常没有任何对象接收，所以程序崩溃
    if(self.superview){
        [self.superview addSubview:_pageControl];
    }else{
        NSLog(@"请先添加到父视图再reloadData");
        @throw nil;
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(_imageArr){
        if (scrollView.contentOffset.x == 0) {
            if (_currentImageIndex == 0) {
                _currentImageIndex = _imageArr.count - 1;
            }else{
                _currentImageIndex--;
            }
        }
        
        if (scrollView.contentOffset.x == VIEW_WIDTH * 2) {
//            NSLog(@"向右滚动");
            if (_currentImageIndex == _imageArr.count - 1) {
                _currentImageIndex = 0;
            }else{
                _currentImageIndex++;
            }
        }
        
        if (_currentImageIndex == 0) {
            [self setImageWithUrlString:_imageArr[_imageArr.count - 1] inImageView:_leftImageView];
            [self setImageWithUrlString:_imageArr[_currentImageIndex] inImageView:_centerImageView];
            [self setImageWithUrlString:_imageArr[_currentImageIndex + 1] inImageView:_rightImageView];
        }else{
            [self setImageWithUrlString:_imageArr[_currentImageIndex - 1] inImageView:_leftImageView];
            [self setImageWithUrlString:_imageArr[_currentImageIndex] inImageView:_centerImageView];
            [self setImageWithUrlString:_imageArr[(_currentImageIndex + 1) % _imageArr.count] inImageView:_rightImageView];
        }
        _pageControl.currentPage = _currentImageIndex;
        if (!isAutoScroll) {
            [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:IMAGE_TIME_INTERVAL]];
        }
        
        isAutoScroll = NO;
        self.contentOffset = CGPointMake(VIEW_WIDTH, 0);
    }
}

-(void)createTimer{
    isAutoScroll = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:IMAGE_TIME_INTERVAL target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
}

-(void)scrollImage{
    isAutoScroll = YES;
    // 向右滚动一次
    [self setContentOffset:CGPointMake(VIEW_WIDTH * 2, 0) animated:YES];
//    self.contentOffset = CGPointMake(VIEW_WIDTH * 2, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollViewDidEndDecelerating:self];
    });
}

-(void)reloadData{
    [self createPageControl];
    if (_imageArr.count >= 3) {
        _currentImageIndex = 0;
        [self setImageWithUrlString:_imageArr[_imageArr.count - 1] inImageView:_leftImageView];
        [self setImageWithUrlString:_imageArr[_currentImageIndex] inImageView:_centerImageView];
        [self setImageWithUrlString:_imageArr[_currentImageIndex + 1] inImageView:_rightImageView];
        [self createTimer];
    }
}

-(void)setImageWithUrlString:(NSString *)urlString inImageView:(UIImageView *)imageView{
    if ([urlString hasPrefix:@"http://"]) {
        [imageView setImageWithURL:[NSURL URLWithString:urlString]];
    }else{
        [imageView setImage:[UIImage imageNamed:urlString]];
    }
}
@end



