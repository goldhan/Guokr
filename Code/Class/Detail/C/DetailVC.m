//
//  DetailVC.m
//  果壳精选
//
//  Created by 韩金 on 16/8/4.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "DetailVC.h"
#import <WebKit/WebKit.h>
#import "RecommendCell.h"
@interface DetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation DetailVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initTableView];
    [self getHtmlDataFromNet];
    [self getRecommendDataFromNet];
    
    
}
#pragma mark - HandleEvent
- (void)Like:(UIButton *)btn{
    ScrollViewModel *m = [[ScrollViewModel alloc]init];
    m.custom_title = self.custom_title;
    m.picture = self.picture;
    m.article_id = self.article_id;
    if ([[SQLManager shareInstance] isCollectWith:self.custom_title]) {
        [SQLManager alartLikeShow:self with:true];
    }else{
    [[SQLManager shareInstance] insertDataWithTag:2 andScrollModel:m];
        [SQLManager alartLikeShow:self with:false];
    }
}
#pragma mark - UI
- (void)initNav{
   self.navigationController.navigationBar.hidden = false;
   
    UIButton *likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40,80)];
   
    
    [likeBtn  setTitle:@"Like" forState:UIControlStateNormal];
    [likeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [likeBtn addTarget:self action:@selector(Like:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:likeBtn];
   

}
- (void)initTableView{
   
    
    self.tableView = [[UITableView alloc]initWithFrame:FRAME];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 160;
    self.webView = [[WKWebView alloc]initWithFrame:FRAME];
  
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.bounces = NO;
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.detailUrl]];
//    [self.webView loadRequest:request];
     [self.tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = self.webView;
    UILabel *footView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    
    footView.text = @"---END---";
    footView.textAlignment = NSTextAlignmentCenter;
    footView.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    
    self.tableView.tableFooterView = footView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
}
#pragma mark - Net
- (void)getHtmlDataFromNet{
    __weak typeof(self) weakSelf = self;
    [[HttpManager ShareInstance]getHtmlDataFromNet:self.detailUrl andSuccess:^(id object) {
        
        NSString *str = [[NSString alloc]initWithData:object encoding:NSUTF8StringEncoding];
        [weakSelf.webView loadHTMLString:str baseURL:nil];
        
       //       NSLog(@"%f", weakSelf.webView.scrollView.contentSize.height);
       
    } andFail:^(NSError *error) {
        NSLog(@"%@",error);
//        [HttpManager alartShow:weakSelf andAct1Block:^{
//            
//        } andAct2Block:^{
//            [weakSelf getHtmlDataFromNet];
//        }];

    }];
}

- (void)getRecommendDataFromNet{
    __weak typeof(self) weakSelf = self;
    [[HttpManager ShareInstance]getDataFromNet:22 andSuccess:^(id object) {
        for (NSDictionary *dict in object[@"result"]) {
            
            HomeModel *model = [[HomeModel alloc]initWithDictionary:dict error:nil];
                            //                             NSLog(@"%@",model.picArr);
            
            
            [weakSelf.dataSource addObject:model];
        }
        [weakSelf.tableView reloadData];

        
        
    } andFail:^(NSError *error) {
        NSLog(@"%@",error);
        [HttpManager alartShow:weakSelf andAct1Block:^{
            
        } andAct2Block:^{
            [weakSelf getRecommendDataFromNet];
        }];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *model = self.dataSource[indexPath.row];
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = model;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel *model = self.dataSource[indexPath.row];
    DetailVC *DVC = [[DetailVC alloc]init];
    DVC.detailUrl = [model link_v2];
    
    DVC.article_id = [NSString stringWithFormat:@"%@", model.ids];
    DVC.custom_title = model.title;
    if (model.headline_img_tb.length == 0) {
        
        DVC.picture = model.images[0];
    }else{
        
        DVC.picture = model.headline_img_tb;
    }
    
    
    [self.navigationController pushViewController:DVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y >= 0) {
        self.webView.userInteractionEnabled = NO;
    }else{
        self.webView.userInteractionEnabled = YES;
    }
}
#pragma mark - Getter
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

