//
//  DetailVC.h
//  果壳精选
//
//  Created by 韩金 on 16/8/4.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVC : UIViewController
@property (nonatomic,copy) NSString * detailUrl;
@property (nonatomic,strong) ScrollViewModel *model;
@property (nonatomic,copy) NSString * picture;
@property (nonatomic,copy) NSString * custom_title;
@property (nonatomic,copy) NSString * article_id;
@end
