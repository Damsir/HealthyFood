//
//  KDFBaseDAO.h
//  KDF
//
//  Created by qianfeng on 16/1/11.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface KDFBaseDAO : NSObject

- (FMDatabase *)getCurrentDB;

@end
