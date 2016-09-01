//
//  LikeCell.m
//  果壳精选
//
//  Created by 韩金 on 16/8/16.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "LikeCell.h"

@implementation LikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
-(void)setModel:(ScrollViewModel *)model{
    _model = model;
    self.titleL.text = model.custom_title;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
    
}


@end
