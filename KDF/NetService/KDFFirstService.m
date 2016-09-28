//
//  KDFFirstService.m
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFFirstService.h"
#import "AFHTTPRequestOperationManager.h"
#import "KDFFirstModel.h"
#import "KDFFirstDetailModel.h"
#import "KDFFirstDDModel.h"
#import "KDFfirstDDDModel.h"
#import "KDFSecondModel.h"
#import "KDFTipsModel.h"

@implementation KDFFirstService

  // 最新首页 http://gsapi.hhcng.com:9005/album/list?pn=0
- (void)getFirstDataWithURL:(NSString *)urlString andPage:(int)page withComplete:(Compelement)handle{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlString parameters:@{@"pn":@(page)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in responseObject) {
            KDFFirstModel *model = [[KDFFirstModel alloc]initWithDict:dict];
            [arr addObject:model];
        }
        handle(arr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

// http://gsapi.hhcng.com:9005/album/detail?pn=0&aid=1

- (void)getFirstDetailDataWithURL:(NSString *)urlString andID:(int)idnum withComplete:(Compelement)handle{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:urlString parameters:@{@"aid":@(idnum)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in responseObject) {
            KDFFirstDetailModel *model = [[KDFFirstDetailModel alloc]initWithDict:dict];
            [arr addObject:model];
        }
        handle(arr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

// 分类详细界面
// http://gsapi.hhcng.com:9005/r/detail?id=44 从上一model获得id

//最新详细界面
// http://gsapi.hhcng.com:9005/r/detail?id=43862  从上一model获得id
- (void)getFirstDDDatawithURL:(NSString *)urlString andID:(int)idnum withComplete:(Compelement)handle{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger GET:urlString parameters:@{@"id":@(idnum)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            KDFFirstDDModel *model = [[KDFFirstDDModel alloc]init];
            model.maketime = [responseObject objectForKey:@"maketime"];
            model.numofpeople = [responseObject objectForKey:@"numofpeople"];
            for (NSDictionary *dic in [responseObject objectForKey:@"steps"]) {
                KDFfirstDDDModel *model1 = [[KDFfirstDDDModel alloc]initWith:dic];
                [model.DetailArray addObject:model1];
            }
            handle(model);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
    
//分类首页 http://gsapi.hhcng.com:9005/home
- (void)getSecondDataWithComplete:(Compelement)handle{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:SECOND_LIST_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSMutableArray *mutableArr = [NSMutableArray new];
            NSArray *arr = [NSArray new];
            arr = [responseObject objectForKey:@"columns"];
            for (NSDictionary *dict in arr) {
                KDFSecondModel *model = [[KDFSecondModel alloc]initWithDict:dict];
                [mutableArr addObject:model];
            }
            handle(mutableArr);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//分类类别 detail
//http://gsapi.hhcng.com:9005/col/recipes?cid=598&pn=0  ID 拼接
- (void)getSecondDDataWithURL:(NSString *)urlString andID:(int)idnum andPage:(int)page withComplete:(Compelement)handle{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager new];
    [manager GET:urlString parameters:@{@"cid":@(idnum),@"pn":@(page)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //model
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in responseObject) {
            KDFFirstDetailModel *model = [[KDFFirstDetailModel alloc]initWithDict:dict];
            [arr addObject:model];
        }
        handle(arr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
//http://gsapi.hhcng.com:9005/topic/list?pn=0&type=1
- (void)getTipDataWithComplete:(Compelement)handle{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager new];
    [manger GET:TIPS_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *arr = [NSMutableArray new];
        for (NSDictionary *dict in responseObject) {
            KDFTipsModel *model = [[KDFTipsModel alloc]initWithDict:dict];
            [arr addObject:model];
        }
        handle(arr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
