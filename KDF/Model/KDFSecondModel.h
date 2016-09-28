//
//  KDFSecondModel.h
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFSecondModel : NSObject

@property (nonatomic, strong) NSNumber *haspayfor;
@property (nonatomic, strong) NSNumber *idnum;
@property (nonatomic, copy) NSString *colName;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, copy) NSString *pid;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
