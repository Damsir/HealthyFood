//
//  KDFFirstDetailModel.h
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFFirstDetailModel : NSObject
@property (nonatomic, strong) NSNumber *idnum;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *setuptime;
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, strong) NSNumber *ctime;
@property (nonatomic, copy) NSString *numofpeople;
@property (nonatomic, copy) NSString *maketime;
@property (nonatomic, strong) NSNumber *com_num;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *coverPicId;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
