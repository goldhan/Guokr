//
//  MyCollectionView.m
//  果壳精选
//
//  Created by 韩金 on 16/8/4.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "MyCollectionView.h"
#import "MyCollectionCell.h"

@interface MyCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation MyCollectionView


-(void)awakeFromNib{
    [super awakeFromNib];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//    self.backgroundColor = [UIColor clearColor];
    self.collectionView.userInteractionEnabled = NO;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
}


-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
   
    [self.collectionView reloadData];
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataSource.count == 1) {
        return CGSizeMake(self.frame.size.width, self.frame.size.height);
    }else {
         return CGSizeMake((self.frame.size.width - 20 )/ 3.0, (self.frame.size.width - 20 )/ 3.0);
    }
//
//    return CGSizeMake((self.frame.size.width - 20 )/ 3.0, (self.frame.size.width - 20 )/ 3.0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.dataSource.count >= 9) {
        return  9;
    }else if (self.dataSource.count >= 6 && self.dataSource.count < 9) {
        return 6;
    }else{
    return self.dataSource.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item % 5 == 0) {
       
        
    }

    MyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imgUrl = self.dataSource[indexPath.item];
    
    
    return cell;
    
}
@end
