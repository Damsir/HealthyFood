//
//  KDFFirstTableViewCell.m
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFFirstTableViewCell.h"

@implementation KDFFirstTableViewCell

- (void)awakeFromNib {
    
    self.TitelImage.layer.cornerRadius = 40;
    self.TitelImage.layer.borderWidth = 0.5;
    self.TitelImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.TitelImage.layer.masksToBounds =YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
