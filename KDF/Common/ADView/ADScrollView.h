//
//  ADScrollView.h
//  TestADDemo
//
//  Created by wangliang on 15/12/9.
//  Copyright (c) 2015年 wangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADScrollView : UIScrollView

@property(nonatomic, strong)NSArray * imageArr;
-(void)reloadData;

@end
