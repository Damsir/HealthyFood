//
//  KDFSecondCollectionViewCell.m
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFSecondCollectionViewCell.h"

@implementation KDFSecondCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.cornerRadius = 10;
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.imageView.layer.masksToBounds = YES;
}

@end
