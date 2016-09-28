//
//  KDFDAOModel.h
//  KDF
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFDAOModel : NSObject
//model.title  model.intro  model.cover  model.idnum
@property(nonatomic ,copy)NSString *titel;
@property(nonatomic ,copy)NSString *intro;
@property(nonatomic ,copy)NSString *cover;
@property(nonatomic ,strong)NSNumber *idnum;
@end
