//
//  CalendarCell.h
//  果壳精选
//
//  Created by 韩金 on 16/8/3.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (nonatomic,strong) HomeModel *model;
@end
