//
//  RecommendCell.h
//  果壳精选
//
//  Created by 韩金 on 16/8/5.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *userL;
@property (nonatomic,strong) HomeModel *model;
@end
