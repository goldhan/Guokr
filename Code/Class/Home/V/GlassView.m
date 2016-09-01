//
//  GlassView.m
//  果壳精选
//
//  Created by 韩金 on 16/8/5.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "GlassView.h"
#import "LikeCell.h"
@interface GlassView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger tags;

@property (nonatomic,assign) CGRect myFrame;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *setArr;
@property (nonatomic,strong)  UIBlurEffect *blurEffect;

@end
@implementation GlassView
-(instancetype)initWithFrame:(CGRect)frame andSourceFrame:(CGRect)SFrame with:(NSInteger)tags{
    if (self = [super initWithFrame: frame]) {
        self.tags = tags;
        _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        
                self.effect = _blurEffect;
        
//        self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.621];
       
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.alpha = 0;
       _myFrame = frame;
        self.transform = CGAffineTransformMakeScale(1.5,1.5);
//        self.frame = CGRectMake(SFrame.origin.x, frame.origin.y, 0, 0);
        [UIView animateWithDuration:0.25  animations:^{
            self.alpha = 1;
           self.transform = CGAffineTransformMakeScale(1,1);
        }completion:^(BOOL finished) {
            
        } ];
        if (tags == 101) {
            [self makeUI];
        }else{
            [self makeTableView];
        }


    }
    return self;
}
- (void)makeTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    if (self.tags == 102) {
        self.tableView.rowHeight = 90;
        self.dataSource = [NSMutableArray arrayWithArray:[[SQLManager shareInstance] getTableDataWithTag:2]];
//        self.tableView.editing = true;
        
    }
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"setCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LikeCell" bundle:nil] forCellReuseIdentifier:@"likeCell"];
    [self addSubview:self.tableView];
    
}

- (void)makeUI{
    NSArray *title = @[@"今日",@"科技",@"学习",@"生活",@"健康",@"人文",@"自然",@"娱乐"];
    for (NSInteger i = 0; i < 3; i ++) {
        for (NSInteger j = 0 ; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(5 +(( self.frame.size.width - 20 )/3  * j)+ 5,
                                   10 + i * 30,
                                   (self.frame.size.width - 20 )/3,
                                   20);
            if (i * 3 + j > 7) {
                break;
            }
            [btn setTitle:title[i * 3 + j] forState:UIControlStateNormal];
            btn.tag = 500 + i * 3 + j;
            [btn addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    
}
- (void)typeClick:(UIButton *)btn{
    if (self.GBtn) {
        self.GBtn(btn);
    }
}
#pragma mark - UITableViewDataSource
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
         ScrollViewModel *model = self.dataSource[indexPath.row];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
        [[SQLManager shareInstance] deleteBy:model.custom_title];
//        [tableView reloadData];
   
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.tags == 100) {
        return self.setArr.count;
    }else{
        return self.dataSource.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (self.tags == 100) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        if (indexPath.row == 1) {
             NSInteger size = [[SDImageCache sharedImageCache]getSize];
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%.1lfMB)", self.setArr[indexPath.row],size / 1024.0 / 1024];
        }else{
        cell.textLabel.text = self.setArr[indexPath.row];
        
        }
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;
    }else{
        LikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"likeCell"];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tags == 100) {
        self.glassBlock(indexPath.row);
    }else{
        self.Glike(self.dataSource[indexPath.row]);
    }
    
}
#pragma mark - Getter
-(NSMutableArray *)setArr{
    if (_setArr == nil) {
        NSString *str;
        if (self.isNight) {
            str = @"日间模式";
           
        }else{
            str = @"夜间模式";
        }
        _setArr = [NSMutableArray arrayWithObjects:str,@"清理缓存",@"反馈与我", nil];
        
    }
    return _setArr;
}
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
