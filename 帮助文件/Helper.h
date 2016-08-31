//
//  Helper.h
//  PalmKitchen
//
//  Created by apple on 14-10-14.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+(UIButton *)createButton:(CGRect)frame title:(NSString *)title image:(UIImage *)image target:(id)target selector:(SEL)selector;

//字符串文字的长度
+(CGFloat)widthOfString:(NSString *)string font:(UIFont*)font height:(CGFloat)height;

//字符串文字的高度
+(CGFloat)heightOfString:(NSString *)string font:(UIFont*)font width:(CGFloat)width;

//获取今天的日期：年月日
+(NSDictionary *)getTodayDate;


// 时间比较
+(NSString *)compareFromDate:(NSDate *)from toDate:(NSDate *)to;



//邮箱
+ (BOOL) justEmail:(NSString *)email;

//手机号码验证
+ (BOOL) justMobile:(NSString *)mobile;

//车牌号验证
+ (BOOL) justCarNo:(NSString *)carNo;

//车型
+ (BOOL) justCarType:(NSString *)CarType;

//用户名
+ (BOOL) justUserName:(NSString *)name;

//密码
+ (BOOL) justPassword:(NSString *)passWord;

//昵称
+ (BOOL) justNickname:(NSString *)nickname;

//身份证号
+ (BOOL) justIdentityCard: (NSString *)identityCard;


@end


