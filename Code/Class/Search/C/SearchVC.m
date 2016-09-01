//
//  SearchVC.m
//  Science有意思
//
//  Created by 韩金 on 16/9/1.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "SearchVC.h"
#import "RecommendCell.h"

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger page;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNav];
    [self initTableView];
    [self Refresh];
    [self getHotWordFromNet];
}
#pragma mark - HandleEvent
- (void)searchBtn:(UIButton *)btn{
    if (self.textField.text.length != 0) {
        [self getResultFromNet];
        [self.textField endEditing:true];
    }else{
        [RKDropdownAlert title:(NSString*)@"提示"
                       message:(NSString*)@"请输入关键字！"
               backgroundColor:(UIColor*)[UIColor colorWithRed:1.000 green:0.847 blue:0.551 alpha:1.000]
                     textColor:(UIColor*)[UIColor whiteColor]
                          time:(NSInteger)3 ] ;
        
    }
    
}

#pragma mark - UI
- (void)Refresh{
    __weak typeof(self) weakSelf = self;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 0;
        
       
        if (weakSelf.textField.text.length != 0) {
            [weakSelf getResultFromNet];
        }else{
            
            [weakSelf getHotWordFromNet];
        }
        
        
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
       
        
        
        if (weakSelf.textField.text.length != 0) {
             weakSelf.page += 20;
            [weakSelf getResultFromNet];
        }else{
            
            [weakSelf getHotWordFromNet];
        }
    }];
    
    
}

- (void)initNav{
    self.navigationController.navigationBar.hidden = false;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBtn:)];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 200, 21)];
    self.textField.layer.borderWidth = 1;
    self.textField.textColor = [UIColor whiteColor];
    self.textField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationItem.titleView = self.textField;
    
}
- (void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:FRAME];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UILabel *footView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    footView.text = @"---END---";
    footView.textAlignment = NSTextAlignmentCenter;
    footView.textColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    self.tableView.tableFooterView = footView;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HotCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendCell" bundle:nil] forCellReuseIdentifier:@"SCell"];
    [self.view addSubview:self.tableView];
}
#pragma mark - Net
- (void)getHotWordFromNet{
    [[HttpManager ShareInstance] getDataFromNet:3 andSuccess:^(id object) {
        
        if ([object[@"result"][0][@"items"] count] != 0 ) {
            [self.dataSource removeAllObjects];
            for ( NSDictionary *dic  in object[@"result"][0][@"items"] ){
                if ([dic[@"text"] length] != 0) {
                    [self.dataSource addObject:dic[@"text"]];
                }
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } andFail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
}
- (void)getResultFromNet{
    [[HttpManager ShareInstance]getDataFromNet:31 andPage_id:self.page andType:self.textField.text  andSuccess:^(id object) {
        if ([object[@"result"] count] != 0) {
            if (self.page == 0) {
                [self.dataSource removeAllObjects];
            }
            for (NSDictionary *dic in object[@"result"]) {
                HomeModel *model = [[HomeModel alloc]initWithDictionary:dic error:nil];
                model.headline_img_tb = model.headline_img;
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
        }else{
            [RKDropdownAlert title:(NSString*)@"提示" message:(NSString*)@"没有搜索到！" backgroundColor:(UIColor*)[UIColor colorWithRed:1.000 green:0.847 blue:0.551 alpha:1.000] textColor:(UIColor*)[UIColor whiteColor] time:(NSInteger)3 ] ;
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } andFail:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"%@",error);
    }];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.textField.text.length != 0) {
        
        return 160;
        
    }else{
        return 40;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.textField.text.length != 0 ) {
        
        RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SCell"];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell"];
        cell.textLabel.text = self.dataSource[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.8];
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.textField.text.length != 0) {
        HomeModel *model = self.dataSource[indexPath.row];
        
        DetailVC *DVC = [[DetailVC alloc]init];
        
        DVC.detailUrl = [NSString stringWithFormat:kDetail,model.ids.integerValue];
        
        DVC.article_id = [NSString stringWithFormat:@"%@", model.ids];
        DVC.custom_title = model.title;
        if (model.headline_img_tb.length == 0) {
            
            DVC.picture = model.images[0];
        }else{
            
            DVC.picture = model.headline_img_tb;
        }
        
        [self.navigationController pushViewController:DVC animated:YES];
        
        
        
    }else{
        self.textField.text = self.dataSource[indexPath.row];
        [self getResultFromNet];
        
    }
    
}

#pragma mark - Getter
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
