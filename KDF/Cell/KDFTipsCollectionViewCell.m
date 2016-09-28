//
//  KDFTipsCollectionViewCell.m
//  KDF
//
//  Created by qianfeng on 16/1/12.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFTipsCollectionViewCell.h"

@implementation KDFTipsCollectionViewCell

- (void)awakeFromNib {
        self.titleImageView.layer.cornerRadius = 10;
        self.titleImageView.layer.borderWidth = 1;
        self.titleImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.titleImageView.layer.masksToBounds = YES;
}

@end
