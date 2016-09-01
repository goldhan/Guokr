//
//  HomeCell.h
//  果壳精选
//
//  Created by 韩金 on 16/7/31.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *userL;

@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (nonatomic,strong) HomeModel *model;
@end
