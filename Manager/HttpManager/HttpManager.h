//
//  HttpManager.h
//  果壳精选
//
//  Created by 韩金 on 16/7/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlock)(id object); //!< 成功返回数据
typedef void (^fail)(NSError *error); //!< 失败返回错误

typedef void (^act1)();
typedef void (^act2)();

@interface HttpManager : NSObject
- (void)getDataFromNet:(NSInteger)tags andSuccess:(successBlock)succ andFail:(fail)fail;
- (void)getDataFromNet:(NSInteger)tags andPage_id:(NSInteger)page andType:(NSString *)type andSuccess:(successBlock)succ andFail:(fail)fail;
- (void)getHtmlDataFromNet:(NSString *)url andSuccess:(successBlock)succ andFail:(fail)fail;
+ (void)alartShow:(id)VC andAct1Block:(act1)btn1 andAct2Block:(act2)btn2;
+ (void)alartShow:(UIViewController *)VC;

+(instancetype)ShareInstance;
@end
