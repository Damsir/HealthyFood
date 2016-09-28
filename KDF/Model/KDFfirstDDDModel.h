//
//  KDFfirstDDDModel.h
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFfirstDDDModel : NSObject
@property(nonatomic ,copy)NSString *img;
@property(nonatomic ,copy)NSString *desc;

- (instancetype)initWith:(NSDictionary *)dict;
@end
