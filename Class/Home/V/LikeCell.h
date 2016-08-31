//
//  LikeCell.h
//  果壳精选
//
//  Created by 韩金 on 16/8/16.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic,strong) ScrollViewModel *model;
@end
