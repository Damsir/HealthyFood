//
//  KDFFirstDDModel.h
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDFFirstDDModel : NSObject

@property(nonatomic ,copy)NSString *maketime;
@property(nonatomic ,copy)NSString *numofpeople;
@property(nonatomic ,strong)NSMutableArray *DetailArray;

- (instancetype)init;

@end
