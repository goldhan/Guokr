//
//  HomeModel.m
//  果壳精选
//
//  Created by 韩金 on 16/7/31.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.picArr = [NSMutableArray array];
    }
    return self;
}
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+ (JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"ids",@"source_data.title":@"userTitle"}];
}

@end
