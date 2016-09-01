//
//  ScrollViewModel.h
//  果壳精选
//
//  Created by 韩金 on 16/7/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "JSONModel.h"

@interface ScrollViewModel : JSONModel
@property (nonatomic,copy) NSString * picture;
@property (nonatomic,copy) NSString * custom_title;
@property (nonatomic,copy) NSString * article_id;
@end
