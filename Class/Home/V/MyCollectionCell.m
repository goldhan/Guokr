//
//  MyCollectionCell.m
//  果壳精选
//
//  Created by 韩金 on 16/8/4.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "MyCollectionCell.h"
@interface MyCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end
@implementation MyCollectionCell
-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"arrow"]];
     [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

@end
