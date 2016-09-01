//
//  HomeVC.m
//  果壳精选
//
//  Created by 韩金 on 16/7/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HomeVC.h"
#import "ADView.h"
#import "HomeCell.h"
#import "CalendarCell.h"
#import "PicCell.h"

#import "GlassView.h"

@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *ScrollArr;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger tags;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,strong) ADView *adView;
@property (nonatomic,strong) UIView *hearV;
@property (nonatomic,strong) UIView *itemV;
@property (nonatomic,strong) UIImageView *hearView;
@property (nonatomic,assign) BOOL isNight;
@property (nonatomic,strong) NSMutableDictionary *typeDic;
@property (nonatomic,strong) GlassView *GlassV;
@property (nonatomic,strong) UIButton *searchBtn;

@end

@implementation HomeVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.hidden = true;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = @"tody";
    self.page = 0;
    self.tags = 1;
    self.isNight = NO;
    [self initNAV];
    [self initTableView];
    [self buttons];
    [self firstView];
    [self getDataFromDB];
    [self getFirstPageDataFromNet];
    [self getScrollDataFromNet];
    [self getDataFromNet];
    [self Refresh];
    
    
    
}
#pragma mark - getDataFromDB
- (void)getDataFromDB{
    [self.adView.dataSource removeAllObjects];
    [self.dataSource removeAllObjects];
    
    self.adView.dataSource = [NSMutableArray arrayWithArray:[[SQLManager shareInstance] getTableDataWithTag:3]];
    [self.adView.collectionView reloadData];
    
    self.dataSource = [NSMutableArray arrayWithArray:[[SQLManager shareInstance] getTableDataWithTag:1]];
    [self.tableView reloadData];
    
}

#pragma mark - Net
- (void)getFirstPageDataFromNet{
    
    [[HttpManager ShareInstance]getDataFromNet:0 andSuccess:^(id object) {
        NSInteger i = 0;
        for (NSDictionary *dict in object[@"result"]) {
            FirestPageModel *model = [[FirestPageModel alloc]initWithDictionary:dict error:nil];
            if (model.image.length != 0) {
                if (i == 0) {
                    [[SQLManager shareInstance] deleteAllWithTag:0];
                }
                [[UIImageView new] sd_setImageWithURL:[NSURL URLWithString:model.image]];
                [[SQLManager shareInstance] insertDataWithTag:0 andFirstPageModel:model];
            }
            i++;
        }
        
        
    } andFail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)getScrollDataFromNet{
    __weak typeof(self) weakSelf = self;
    [[HttpManager ShareInstance]getDataFromNet:11 andSuccess:^(id object) {
        [[SQLManager shareInstance]deleteAllWithTag:3];
        for (NSDictionary *dict in object[@"result"]) {
            ScrollViewModel *model = [[ScrollViewModel alloc]initWithDictionary:dict error:nil];
            if (model.picture.length != 0) {
                [weakSelf.ScrollArr addObject:model];
                [[SQLManager shareInstance] insertDataWithTag:3 andScrollModel:model];
            }
            
            
        }
        weakSelf.adView.dataSource = [NSMutableArray arrayWithArray:weakSelf.ScrollArr];
        //        weakSelf.adView.pageControl.numberOfPages = weakSelf.ScrollArr.count;
        
        [weakSelf.adView.collectionView reloadData];
        
    } andFail:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}

- (void)getDataFromNet{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *typeArr = [NSMutableArray array];
    [[HttpManager ShareInstance]getDataFromNet:self.tags andPage_id:self.page andType:self.type andSuccess:^(id object) {
        if (weakSelf.page == 0) {
            [weakSelf.dataSource removeAllObjects];
            [[SQLManager shareInstance] deleteAllWithTag:1];
        }
        
        for (NSDictionary *dict in object[@"result"]) {
            
            HomeModel *model = [[HomeModel alloc]initWithDictionary:dict error:nil];
            if ([model.style isEqualToString:@"pic"]) {
                NSData *data = [model.content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSInteger count = 0;
                for (NSDictionary *dict in dic[@"pics"]) {
                    if (count >= 3) {
                        break ;
                    }
                    [model.picArr addObject:dict[@"url"]];
                    count++;
                    
                }
                //                             NSLog(@"%@",model.picArr);
            }
            [[SQLManager shareInstance] insertDataWithTag:1 andHomeModel:model];
            [typeArr addObject:model];
            [weakSelf.dataSource addObject:model];
            
        }
        [weakSelf.tableView reloadData];
        [self.typeDic setObject:typeArr forKey:self.type];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } andFail:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSLog(@"%@",error);
        [HttpManager alartShow:weakSelf andAct1Block:^{
            UIVisualEffectView *blurView = (UIVisualEffectView *)[self.view viewWithTag:666];
            [blurView removeFromSuperview];
        } andAct2Block:^{
            UIVisualEffectView *blurView = (UIVisualEffectView *)[self.view viewWithTag:666];
            [blurView removeFromSuperview];
            [weakSelf getDataFromNet];
        }];
        
    }];
}

#pragma mark - UI
- (void)initNAV{
    self.navigationController.navigationBar.barStyle =  UIBarStyleBlack;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    backItem.tintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (void)firstView{
    NSArray *firstPageArr = [[SQLManager shareInstance]getTableDataWithTag:0];
    UIImageView *firstView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //    firstView.image = [UIImage imageNamed:@"launchImage 4.7"];
    //    NSLog(@"%ld",firstPageArr.count);
    if (firstPageArr.count != 0) {
        FirestPageModel *model1 = firstPageArr[0];
        FirestPageModel *model2 = firstPageArr[1];
        FirestPageModel *model3 = firstPageArr[2];
        FirestPageModel *model4 = firstPageArr[3];
        
        if (model1.image.length != 0) {
            CGFloat heigh =  [UIScreen mainScreen].bounds.size.height;
            if ( heigh == 480) {
                [firstView sd_setImageWithURL:[NSURL URLWithString:model1.image] placeholderImage:[UIImage imageNamed:@"launchImage 4.7@2x"]];
            }else if (heigh == 667){
                [firstView sd_setImageWithURL:[NSURL URLWithString:model3.image] placeholderImage:[UIImage imageNamed:@"launchImage 4.7@2x"]];
            }else if (heigh == 736){
                [firstView sd_setImageWithURL:[NSURL URLWithString:model4.image] placeholderImage:[UIImage imageNamed:@"launchImage 4.7@2x"]];
            }else{
                [firstView sd_setImageWithURL:[NSURL URLWithString:model2.image] placeholderImage:[UIImage imageNamed:@"launchImage 4.7@2x"]];
            }
            [self.view addSubview:firstView];
            self.view.userInteractionEnabled = false;
            [UIView animateWithDuration:5 animations:^{
                
                firstView.transform = CGAffineTransformMakeScale(1.5,1.5);
            } completion:^(BOOL finished) {
                [firstView removeFromSuperview];
                self.view.userInteractionEnabled = true;
            }];
            
        }
        
    }
    
    
}
- (void)buttons{
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(0, HEIGHT - 10 - 50, 80, 30);
    [self.searchBtn setTitle:@"Search" forState:UIControlStateNormal];
    self.searchBtn.backgroundColor = [UIColor colorWithRed:0.267 green:0.510 blue:1.000 alpha:1.000];
    [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
}
- (void)Refresh{
    __weak typeof(self) weakSelf = self;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self.ScrollArr removeAllObjects];
        //        [self.dataSource removeAllObjects];
        [weakSelf getScrollDataFromNet];
        [weakSelf getDataFromNet];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.page += 20;
        
        [weakSelf getDataFromNet];
    }];
    
    
}


- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    //    self.tableView.rowHeight = 160;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hearView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.45 * HEIGHT)];
    self.hearView.image = [UIImage imageNamed:@"Rectangle"];
    self.hearView.backgroundColor = [UIColor colorWithRed:0.075 green:0.161 blue:0.283 alpha:1.000];
    [self.view addSubview:self.hearView];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.hearV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.hearView.frame.size.height - 64)];
    //    view.backgroundColor = [UIColor redColor];
    self.adView = [[ADView alloc]initWithFrame:CGRectMake(0, 46, WIDTH, self.hearView.frame.size.height * 0.666)];
    __weak typeof(self) weakSelf = self;
    //
    self.adView.advBlock = ^(id obj){
        //        NSLog(@"%@",ids);
        DetailVC *DVC = [[DetailVC alloc]init];
        ScrollViewModel *model = obj;
        DVC.article_id = model.article_id;
        DVC.custom_title = model.custom_title;
        DVC.picture = model.picture;
        
        DVC.detailUrl = [NSString stringWithFormat:kDetail,model.article_id.integerValue];
        [weakSelf.navigationController pushViewController:DVC animated:YES];
        
    };
    
    
    self.hearV.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CalendarCell" bundle:nil] forCellReuseIdentifier:@"Ccell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PicCell" bundle:nil] forCellReuseIdentifier:@"Pcell"];
    self.tableView.tableHeaderView = self.hearV;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UILabel *footView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    
    footView.text = @"---下拉加载更多---";
    footView.textAlignment = NSTextAlignmentCenter;
    footView.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    self.tableView.tableFooterView = footView;
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.adView];
    
    
    
    self.itemV = [[UIView alloc]initWithFrame:CGRectMake(15, self.hearView.frame.size.height - HEIGHT * 0.066, WIDTH - 15, HEIGHT * 0.066)];
    NSArray *title = @[@"Set",@"今日",@"Like"];
    for (NSInteger i = 0; i < 3; i++) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(i * (65 + (self.itemV.frame.size.width - 65 * 3)/2), 0, 65, HEIGHT * 0.066)];
        lable.text = title[i];
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:HEIGHT * 0.04];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [lable addGestureRecognizer:tap];
        lable.userInteractionEnabled = YES;
        lable.tag = 100 + i;
        [self.itemV addSubview:lable];
    }
    
    [self.view addSubview:self.itemV];
}
#pragma mark - HandleEvent

- (void)searchBtn:(UIButton *)btn{
    SearchVC *VC= [[SearchVC alloc]init];
    [self.navigationController pushViewController:VC animated:true];
}
- (void)tap:(UITapGestureRecognizer *)tap{
    UILabel *lab = (UILabel *)tap.view;
    __weak typeof(self) weakSelf = self;
    if (lab.tag == 101) {
        self.GlassV = [[GlassView alloc]initWithFrame:CGRectMake(40, _itemV.frame.origin.y + _itemV.frame.size.height + 5, WIDTH - 80, 100) andSourceFrame:lab.frame with:lab.tag];
        [self.view addSubview:self.GlassV];
        self.tableView.userInteractionEnabled = NO;
        self.itemV.userInteractionEnabled = NO;
        UILabel *tody = (UILabel *)[self.view viewWithTag:101];
        
        self.GlassV.GBtn = ^(UIButton *btn){
            
            [weakSelf getTypeData:btn.tag];
            tody.text = btn.titleLabel.text;
        };
        
        
        
        
    }else if (lab.tag == 100){
        self.GlassV = [[GlassView alloc]initWithFrame:CGRectMake(8, _itemV.frame.origin.y + _itemV.frame.size.height + 5, WIDTH * 0.45, 3 * 44)andSourceFrame:lab.frame with:100];
        self.GlassV.isNight = self.isNight;
        [self.view addSubview:self.GlassV];
        self.tableView.userInteractionEnabled = NO;
        self.itemV.userInteractionEnabled = NO;
        
        self.GlassV.glassBlock = ^(NSInteger row){
            if (row == 0) {
                weakSelf.isNight = !weakSelf.isNight;
                if (weakSelf.isNight) {
                    [weakSelf.tableView reloadData];
                    weakSelf.hearView.image = nil;
                    weakSelf.view.backgroundColor = [UIColor colorWithWhite:0.250 alpha:1.000];
                }else{
                    [weakSelf.tableView reloadData];
                    weakSelf.hearView.image = [UIImage imageNamed:@"Rectangle"];
                    weakSelf.view.backgroundColor = [UIColor whiteColor];
                }
                
                
            }else if (row == 1){
                [HttpManager alartShow:weakSelf];
                //                [weakSelf.GlassV.tableView reloadData];
            }else if (row == 2){
                [weakSelf launchMailApp];
            }
            
            
        };
    }else{
        self.GlassV = [[GlassView alloc]initWithFrame:CGRectMake(8, 20, WIDTH - lab.frame.size.width - 20, HEIGHT * 0.65)andSourceFrame:lab.frame with:102];
        [self.view addSubview:self.GlassV];
        self.tableView.userInteractionEnabled = NO;
        self.itemV.userInteractionEnabled = NO;
        
        self.GlassV.Glike = ^(ScrollViewModel *model){
            DetailVC *DVC = [[DetailVC alloc]init];
            
            DVC.article_id = model.article_id;
            DVC.custom_title = model.custom_title;
            DVC.picture = model.picture;
            
            DVC.detailUrl = [NSString stringWithFormat:kDetail,model.article_id.integerValue];
            [weakSelf.navigationController pushViewController:DVC animated:YES];
            
        };
        
    }
    
    
    
}
- (void)getTypeData:(NSInteger)tag{
    __weak typeof(self) weakSelf = self;
    switch (tag) {
        case 500:
            weakSelf.tags = 1;
            weakSelf.type = @"tody";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
        case 501:
            weakSelf.tags = 2;
            weakSelf.type = @"science";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
        case 502:
            weakSelf.tags = 2;
            weakSelf.type = @"learning";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
        case 503:
            weakSelf.tags = 2;
            weakSelf.type = @"life";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
            
        case 504:
            weakSelf.tags = 2;
            weakSelf.type = @"health";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
        case 505:
            weakSelf.tags = 2;
            weakSelf.type = @"humanities";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
        case 506:
            weakSelf.tags = 2;
            weakSelf.type = @"nature";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
        case 507:
            weakSelf.tags = 2;
            weakSelf.type = @"entertainment";
            if ([weakSelf.typeDic[weakSelf.type] count] == 0) {
                [weakSelf getDataFromNet];
            }else{
                weakSelf.dataSource = [NSMutableArray arrayWithArray:weakSelf.typeDic[weakSelf.type]];
                [weakSelf.tableView reloadData];
            }
            
            break;
            
        default:
            break;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.GlassV != nil) {
        [UIView animateWithDuration:0.25 animations:^{
            self.GlassV.alpha = 0;
            self.GlassV.transform = CGAffineTransformMakeScale(1.5,1.5);
        } completion:^(BOOL finished) {
            [self.GlassV removeFromSuperview];
            self.tableView.userInteractionEnabled = YES;
            self.itemV.userInteractionEnabled = YES;
        }];
        
        
        
    }
}
#pragma mark - 使用系统邮件客户端发送邮件
-(void)launchMailApp
{
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"634824726@qq.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = @[@""];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = @[@""];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"&subject=果壳精选反馈"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>谢谢!</b>"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HomeModel *model = self.dataSource[indexPath.row];
    if ([model.style isEqualToString:@"calendar"]) {
        return 300;
    }else if ([model.style isEqualToString:@"pic"]){
        if (model.picArr.count >= 3) {
            return 40 + (WIDTH - 16) / 3 + 55;
            
        }else{
            return 300;
        }
        
    }else{
        return 160;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row % 20 == 0) {
    //        [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    //        //        NSLog(@"clear SD_image");
    //    }
    PicCell *pcell = [tableView dequeueReusableCellWithIdentifier:@"Pcell"];
    CalendarCell *ccell = [tableView dequeueReusableCellWithIdentifier:@"Ccell"];
    HomeCell *hcell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    HomeModel *model = self.dataSource[indexPath.row];
    if ([model.style isEqualToString:@"calendar"]) {
        
        if (self.isNight) {
            ccell.backgroundColor = [UIColor colorWithWhite:0.250 alpha:1.000];
        }else{
            ccell.backgroundColor = [UIColor whiteColor];
        }
        
        ccell.model = model;
        return ccell;
    }else if ([model.style isEqualToString:@"pic"]){
        
        pcell.model = model;
        if (self.isNight) {
            pcell.backgroundColor = [UIColor colorWithWhite:0.250 alpha:1.000];
        }else{
            pcell.backgroundColor = [UIColor whiteColor];
        }
        
        return pcell;
    }else{
        
        if (self.isNight) {
            hcell.backgroundColor = [UIColor colorWithWhite:0.250 alpha:1.000];
            
            hcell.backImg.hidden = YES;
        }else{
            hcell.backgroundColor = [UIColor whiteColor];
            hcell.backImg.hidden = NO;;
        }
        hcell.model = model;
        return hcell;
        
    }
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel *model = self.dataSource[indexPath.row];
    DetailVC *DVC = [[DetailVC alloc]init];
    DVC.detailUrl = [model link_v2];
    
    DVC.article_id = [NSString stringWithFormat:@"%@", model.ids];
    DVC.custom_title = model.title;
    if (model.headline_img_tb.length == 0) {
        if (model.images.count != 0) {
            DVC.picture = model.images[0];
        }else{
            DVC.picture = @"";
        }
        
        
    }else{
        
        DVC.picture = model.headline_img_tb;
    }
    
    
    [self.navigationController pushViewController:DVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0) {
        self.adView.alpha = 1 / (scrollView.contentOffset.y * -1);
    }else{
        self.adView.alpha = 1 ;
    }
    
    
    self.adView.frame = CGRectMake(0, 46 - scrollView.contentOffset.y, WIDTH, self.hearView.frame.size.height * 0.666);
    if (scrollView.contentOffset.y <= self.hearView.frame.size.height - 64) {
        self.itemV.frame = CGRectMake(15, self.hearView.frame.size.height - HEIGHT * 0.066 - scrollView.contentOffset.y, WIDTH - 15, HEIGHT * 0.066);
    }else{
        //        NSLog(@"%f",self.itemV.frame.origin.y);
        [UIView animateWithDuration:0.1 animations:^{
            self.itemV.frame = CGRectMake(15, 20 , WIDTH - 15, HEIGHT * 0.066);
        }];
        
    }
    //    self.itemV.frame = CGRectMake(15, self.hearView.frame.size.height - 44 - scrollView.contentOffset.y, WIDTH - 15, 44);
}
#pragma mark - Getter
- (NSMutableDictionary *)typeDic{
    if (_typeDic == nil ) {
        _typeDic = [NSMutableDictionary dictionary];
    }
    return _typeDic;
}
-(NSMutableArray *)ScrollArr{
    if (_ScrollArr == nil) {
        _ScrollArr = [NSMutableArray array];
    }
    return _ScrollArr;
}
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
