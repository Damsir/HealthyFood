//
//  KDFBaseDAO.m
//  KDF
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFBaseDAO.h"
#import "FMDB.h"

@implementation KDFBaseDAO

- (FMDatabase *)getCurrentDB{
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString * path = [NSString stringWithFormat:@"%@%@", documentPath, @"/mycontact.db"];
    NSLog(@"%@", path);
    NSLog(@"**%@", NSHomeDirectory());
    // 得到数据库，如果没有则创建一个数据库
    FMDatabase * db = [FMDatabase databaseWithPath:path];
    // 如果数据库可以打开
    if ([db open]) {
        if (![db tableExists:@"mycontact"]) {
            //cname varchar(100)->titel, ctel varchar(1000)->cover, cphoto varchar(2000)->intro;idnum varchar(10)->idnum
            NSString * createSQL  = @"create table mycontact(cid integer primary key autoincrement, titel varchar(100), cover varchar(1000), intro varchar(2000),idnum varchar(20));";
            if ([db executeStatements:createSQL]) {
                NSLog(@"创建成功");
            }else{
                NSLog(@"创建失败");
            }
        }
        [db close];
    }
    return db;
}


@end
