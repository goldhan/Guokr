//
//  CalendarCell.m
//  果壳精选
//
//  Created by 韩金 on 16/8/3.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "CalendarCell.h"

@implementation CalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeL.layer.cornerRadius = self.typeL.frame.size.height / 2;
    self.typeL.layer.masksToBounds = YES;

}
-(void)setModel:(HomeModel *)model{
    _model = model;
    self.titleL.text = model.title;
    self.detailL.text = model.summary;
    
    if (model.headline_img_tb.length == 0) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
    }else{
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.headline_img_tb] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
