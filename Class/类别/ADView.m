//
//  ADView.m
//  果壳精选
//
//  Created by 韩金 on 16/7/31.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "ADView.h"
#import "AdvCell.h"
@interface ADView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@end


@implementation ADView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = [NSMutableArray array];
        [self makeUI];
    }
    return self;
}
- (void)makeUI{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.sectionInset = UIEdgeInsetsMake(0, 18, 0, 18);
    flow.minimumLineSpacing = 36;
    flow.minimumInteritemSpacing = 36;
    flow.itemSize =CGSizeMake(self.frame.size.width - 36, self.frame.size.height);
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flow];
    self.collectionView.contentOffset = CGPointMake(WIDTH, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AdvCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:self.collectionView];
    _pageControl =  [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 30)];
//    self.pageControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:self.pageControl];

    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
   self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(Move:) userInfo:nil repeats:YES];
    self.pageControl.numberOfPages = self.dataSource.count;
    if (self.dataSource.count == 0) {
        return 0;
    }
    return self.dataSource.count + 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AdvCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.item == 0){
        ScrollViewModel *model = self.dataSource[self.dataSource.count - 1];
        [cell.topImgV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
        cell.titleL.text = model.custom_title;

    }else if (indexPath.item == self.dataSource.count + 1){
        ScrollViewModel *model = self.dataSource[0];
        [cell.topImgV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
        cell.titleL.text = model.custom_title;

    }else{
        ScrollViewModel *model = self.dataSource[indexPath.item - 1];
        [cell.topImgV sd_setImageWithURL:[NSURL URLWithString:model.picture] placeholderImage:[UIImage imageNamed:@"Rectangle"]];
        cell.titleL.text = model.custom_title;

    }
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",[self.dataSource[indexPath.item] article_id]);
    ScrollViewModel *model;
    if(indexPath.item == 0){
        model = self.dataSource[self.dataSource.count - 1];
        
    }else if (indexPath.item == self.dataSource.count + 1){
        model = self.dataSource[0];
        
    }else{
        model = self.dataSource[indexPath.item - 1];
        
    }

    if (self.advBlock) {
        self.advBlock(model);
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    if (x == 0) {
        self.collectionView.contentOffset = CGPointMake(self.dataSource.count * WIDTH, 0);
    }else if (x == (self.dataSource.count + 1) * WIDTH){
        self.collectionView.contentOffset = CGPointMake(WIDTH, 0);
    }
   
    self.pageControl.currentPage = scrollView.contentOffset.x / self.bounds.size.width - 1;
    
}
- (void)Move:(NSTimer *)timer{
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + WIDTH, 0) animated:YES];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger count = scrollView.contentOffset.x / WIDTH;
    if (count == 0) {
        self.pageControl.currentPage = self.dataSource.count;
        self.collectionView.contentOffset = CGPointMake((self.dataSource.count - 1) * WIDTH, 0);
    }else if (count == self.dataSource.count + 1){
        self.pageControl.currentPage = 0;
        self.collectionView.contentOffset = CGPointMake( WIDTH, 0);
    }else{
        self.pageControl.currentPage = count - 1;
    }
}
@end
