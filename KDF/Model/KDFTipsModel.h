//
//  KDFTipsModel.h
//  KDF
//
//  Created by qianfeng on 16/1/12.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFTipsModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *idnum;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *create_time;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *des;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
