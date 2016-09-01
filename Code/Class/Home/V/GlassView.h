//
//  GlassView.h
//  果壳精选
//
//  Created by 韩金 on 16/8/5.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Gblock)(NSInteger);
typedef void (^GBtn)(UIButton *);
typedef void (^Glike)(ScrollViewModel *);
@interface GlassView : UIVisualEffectView
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) Gblock glassBlock;
@property (nonatomic,copy) GBtn GBtn;
@property (nonatomic,copy) Glike Glike;
@property (nonatomic,assign) BOOL isNight;
- (instancetype)initWithFrame:(CGRect)frame andSourceFrame:(CGRect)SFrame with:(NSInteger)tags;
@end
