//
//  SQLManager.h
//  果壳精选
//
//  Created by 韩金 on 16/8/15.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLManager : NSObject
+(instancetype)shareInstance;
+ (NSData *)arrToData:(NSArray *)arr;
+ (NSArray *)dataToArr:(NSData *)data;
- (void)deleteAllWithTag:(NSInteger)tag;
- (NSArray *)getTableDataWithTag:(NSInteger)tag;
- (BOOL)isCollectWith:(NSString *)title;
- (void)deleteBy:(NSString *)title;
- (void)insertDataWithTag:(NSInteger)tag andHomeModel:(HomeModel *)model;
- (void)insertDataWithTag:(NSInteger)tag andScrollModel:(ScrollViewModel *)model;
- (void)insertDataWithTag:(NSInteger)tag andFirstPageModel:(FirestPageModel *)model;
+ (void)alartLikeShow:(UIViewController *)VC with:(BOOL)ret;
@end
