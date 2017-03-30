//
//  RecommendCell.m
//  果壳精选
//
//  Created by 韩金 on 16/8/5.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.typeL.layer.cornerRadius = self.typeL.frame.size.height / 2;
    self.typeL.layer.masksToBounds = YES;
}

-(void)setModel:(HomeModel *)model{
    _model = model;
    self.titleL.text = model.title;
    self.detailL.text = model.summary;
    self.userL.text = model.source_name;
    if ([model.category isEqualToString:@"science"]) {
        self.typeL.text = @"科技";
        self.typeL.backgroundColor = [UIColor colorWithRed:0.000 green:0.800 blue:1.000 alpha:1.000];
    }else if([model.category isEqualToString:@"learning"]) {
        self.typeL.text = @"学习";
        self.typeL.backgroundColor = [UIColor colorWithRed:1.000 green:0.800 blue:0.600 alpha:1.000];
    }else if([model.category isEqualToString:@"life"]){
        self.typeL.text = @"生活";
        self.typeL.backgroundColor = [UIColor colorWithRed:1.000 green:0.600 blue:0.000 alpha:1.000];
    }else if([model.category isEqualToString:@"heath"]){
        self.typeL.text = @"健康";
        self.typeL.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.200 alpha:1.000];
    }else if([model.category isEqualToString:@"humanities"]){
        self.typeL.text = @"人文";
        self.typeL.backgroundColor = [UIColor colorWithRed:1.000 green:0.600 blue:1.000 alpha:1.000];
    }else if([model.category isEqualToString:@"nature"]){
        self.typeL.text = @"自然";
        self.typeL.backgroundColor = [UIColor colorWithRed:0.600 green:1.000 blue:0.600 alpha:1.000];
    }else{
        self.typeL.text = @"娱乐";
        self.typeL.backgroundColor = [UIColor colorWithRed:0.600 green:0.200 blue:1.000 alpha:1.000];}
    
    if (model.headline_img_tb.length == 0) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
    }else{
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.headline_img_tb] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
    }
}

@end
