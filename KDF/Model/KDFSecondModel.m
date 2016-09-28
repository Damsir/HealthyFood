//
//  KDFSecondModel.m
//  KDF
//
//  Created by qianfeng on 16/1/8.
//  Copyright © 2016年 kongdefu. All rights reserved.
//

#import "KDFSecondModel.h"

@implementation KDFSecondModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.idnum = value;
    }
}
@end
