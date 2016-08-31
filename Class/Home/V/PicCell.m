//
//  PicCell.m
//  果壳精选
//
//  Created by 韩金 on 16/8/3.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "PicCell.h"
#import "MyCollectionView.h"

@implementation PicCell

- (void)awakeFromNib {
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
    }else if([model.category isEqualToString:@"learning"]) {
        self.typeL.text = @"学习";
    }else if([model.category isEqualToString:@"life"]){
        self.typeL.text = @"生活";
    }else if([model.category isEqualToString:@"heath"]){
        self.typeL.text = @"健康";
    }else if([model.category isEqualToString:@"humanities"]){
        self.typeL.text = @"人文";
    }else if([model.category isEqualToString:@"nature"]){
        self.typeL.text = @"自然";
    }else{
        self.typeL.text = @"娱乐";
    }
    if (model.picArr.count == 1) {
        
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.picArr[0]] placeholderImage:[UIImage imageNamed:@"arrow"]];
    
    }else{
    MyCollectionView *picView = [[NSBundle mainBundle]loadNibNamed:@"MyCollectionView" owner:self options:nil][0];
    picView.backgroundColor = [UIColor clearColor];
    picView.frame = CGRectMake(0, 0, self.imgView.frame.size.width, self.imgView.frame.size.height);
    picView.dataSource = [NSMutableArray arrayWithArray:model.picArr];
    self.imgView.backgroundColor = [UIColor clearColor];
    [self.imgView addSubview:picView];
    }
//    if (model.headline_img_tb.length == 0) {
//        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
//    }else{
//        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model.headline_img_tb] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
