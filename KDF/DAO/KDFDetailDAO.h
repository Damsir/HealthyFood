//
//  KDFDetailDAO.h
//  KDF
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFBaseDAO.h"
@class KDFDAOModel;

@interface KDFDetailDAO : KDFBaseDAO
//添加
-(BOOL)saveContact:(KDFDAOModel *)model;
//查询
-(NSArray *)findAllContacts;
//修改
//-(BOOL)updateContact:(KDFDAOModel *)contact;
//删除
-(BOOL)deleteContact:(NSString *)contactId;
@end
