//
//  KDFFirstModel.h
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFFirstModel : NSObject

@property (nonatomic, copy) NSString *albumContent;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *coverid;
@property (nonatomic, strong) NSNumber *idnum;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *recipeCount;
@property (nonatomic, strong) NSNumber *catchid;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *albumCover;

- (instancetype)initWithDict:(NSDictionary *)dic;

@end
