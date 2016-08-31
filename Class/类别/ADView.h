//
//  ADView.h
//  果壳精选
//
//  Created by 韩金 on 16/7/31.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^block)(id);
@interface ADView : UIView
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,copy) block advBlock;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@end
