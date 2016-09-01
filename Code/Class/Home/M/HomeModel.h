//
//  HomeModel.h
//  果壳精选
//
//  Created by 韩金 on 16/7/31.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "JSONModel.h"

@interface HomeModel : JSONModel
@property (nonatomic,copy) NSString * source_name;
@property (nonatomic,strong) NSNumber * ids;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * userTitle;
@property (nonatomic,copy) NSString * link_v2;
@property (nonatomic,copy) NSString * summary;
@property (nonatomic,copy) NSString * category;
@property (nonatomic,copy) NSString * style;
@property (nonatomic,copy) NSString * content;
@property (nonatomic,strong) NSMutableArray *picArr;
@property (nonatomic,copy) NSString * headline_img_tb;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,copy) NSString * headline_img;
@end
