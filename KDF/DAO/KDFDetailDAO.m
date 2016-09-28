//
//  KDFDetailDAO.m
//  KDF
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFDetailDAO.h"
#import "FMDB.h"
#import "KDFDAOModel.h"

@implementation KDFDetailDAO
-(BOOL)saveContact:(KDFDAOModel *)model{
    //增加
    NSString * insertSQL = @"insert into mycontact (titel, cover, intro,idnum) values(?, ?, ?,?);";
    FMDatabase * db = [self getCurrentDB];
    // 执行添加操作（executeUpdate只能够执行一条语句，executeStatements可以同时执行多条语句）
    if ([db open]) {
         //model.title  model.intro  model.cover  model.idnum
        return [db executeUpdate:insertSQL, model.titel, model.cover,model.intro, model.idnum];
    }
    return NO;
}

-(NSArray *)findAllContacts{
    
    NSString * findSQL = @"select * from mycontact;";
    FMDatabase * db = [self getCurrentDB];
    NSMutableArray * resultArr = [NSMutableArray new];
    
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:findSQL];//得到查询的结果集
        while ([rs next]) {
            KDFDAOModel * m = [KDFDAOModel new];
            // 可以使用列的index，也可以使用列名
            m.titel = [rs stringForColumnIndex:1];
            m.cover = [rs stringForColumnIndex:2];
            m.intro = [rs stringForColumnIndex:3];
            m.idnum = (NSNumber *)[rs stringForColumnIndex:4];
            [resultArr addObject:m];
        }
    }
    return resultArr;
}

-(BOOL)deleteContact:(NSString *)titel{
    //删除
    NSString * deleteSQL = @"delete from mycontact where titel = ?;";
    FMDatabase * db = [self getCurrentDB];
    // 执行添加操作（executeUpdate只能够执行一条语句，executeStatements可以同时执行多条语句）
    if ([db open]) {
        // 开始一个事务（事务的作用是整个事务是一个整体，如果有一个语句操作失败，那么全体操作会回滚，不会执行）
        [db beginTransaction];
        [db executeUpdate:deleteSQL,titel];
        // 提交一个事务
        BOOL isSuccess = [db commit];
        if (isSuccess) {
            return isSuccess;
        }else{
            NSLog(@"删除失败");
        }
    }
    return NO;
}
@end
