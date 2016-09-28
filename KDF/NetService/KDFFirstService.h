//
//  KDFFirstService.h
//  KDF
//
//  Created by qianfeng on 16/1/7.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Compelement)(id data);

@interface KDFFirstService : NSObject

- (void)getFirstDataWithURL:(NSString *)urlString andPage:(int)page withComplete:(Compelement)handle;

- (void)getFirstDetailDataWithURL:(NSString *)urlString andID:(int)idnum withComplete:(Compelement)handle;

- (void)getFirstDDDatawithURL:(NSString *)urlString andID:(int)idnum withComplete:(Compelement)handle;

- (void)getSecondDataWithComplete:(Compelement)handle;

- (void)getSecondDDataWithURL:(NSString *)urlString andID:(int)idnum andPage:(int)page withComplete:(Compelement)handle;

- (void)getTipDataWithComplete:(Compelement)handle;

@end
