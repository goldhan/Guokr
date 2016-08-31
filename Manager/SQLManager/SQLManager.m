//
//  SQLManager.m
//  果壳精选
//
//  Created by 韩金 on 16/8/15.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "SQLManager.h"
@interface SQLManager ()
@property (nonatomic, strong) FMDatabase *dataBase; //!< 数据库对象；
@end

@implementation SQLManager
+(instancetype)shareInstance{
    static SQLManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[SQLManager alloc]init];
        
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //数据库沙盒路径
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/guoke.db"];
        NSLog(@"%@",path);
        
        self.dataBase = [FMDatabase databaseWithPath:path];
        
        //打开数据库
        if ([self.dataBase open]) {
            [self creatTableIlife];
            
            NSLog(@"open succ");
            
        }else{
            NSLog(@"fail");
        }
    }
    return self;
}
- (void)creatTableIlife{
    NSString *todyModel = @"create table if not exists tody (id integer primary key autoincrement,source_name text,ids integer,title text,userTitle text,link_v2 text,summary text,category text,style text,content text,picArr blob,headline_img_tb text,images blob)";
    
    NSString *like = @"create table if not exists like (id integer primary key autoincrement,picture text,custom_title text,article_id text)";
    NSString *first = @"create table if not exists first (id integer primary key autoincrement,image text,spec text)";
    NSString *scroller = @"create table if not exists scroller (id integer primary key autoincrement,picture text,custom_title text,article_id text)";
    
    if (![self.dataBase executeUpdate:todyModel]) {
        NSLog(@"todyModel fail");
    }
    if (![self.dataBase executeUpdate:like]) {
        NSLog(@"like fail");
    }
    if (![self.dataBase executeUpdate:scroller]) {
        NSLog(@"scroller fail");
    }
    if (![self.dataBase executeUpdate:first]) {
        NSLog(@"first fail");
    }
    
    
}
- (void)deleteAllWithTag:(NSInteger)tag{
    NSString *tabkeName = [self tableNameBy:tag];
    NSString *sqlString = [NSString stringWithFormat:@"delete from %@",tabkeName];
    if (![self.dataBase executeUpdate:sqlString]) {
        NSLog(@"%@ 删除失败",tabkeName);
    }
}

- (void)deleteBy:(NSString *)title{
    if (![self.dataBase executeUpdate:@"delete from like where custom_title = ?",title]) {
        NSLog(@"删除失败");
    }
    
}
//检测收藏
- (BOOL)isCollectWith:(NSString *)title{
    //如果你的查询结果只有一条时，可以使用快捷的查找方式
    NSString *str =[ self.dataBase stringForQuery:@"select * from like where custom_title = ?",title];
    if (str.length > 0) {
        return YES;
    }
    return NO;
}

- (NSArray *)getTableDataWithTag:(NSInteger)tag{
    
    NSString *tableName = [self tableNameBy:tag];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *sqlString = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    FMResultSet *set =  [self.dataBase executeQuery:sqlString];
    while ([set next] == YES){
        if (tag >= 2 ) {
            ScrollViewModel *model = [[ScrollViewModel alloc]init];
            model.picture = [set stringForColumn:@"picture"];
            model.custom_title = [set stringForColumn:@"custom_title"];
            model.article_id = [set stringForColumn:@"article_id"];
            [arr addObject:model];
            
        }else if(tag == 0){
        
            FirestPageModel *model = [[FirestPageModel alloc]init];
            model.image = [set stringForColumn:@"image"];
            model.spec = [set stringForColumn:@"spec"];
            [arr addObject:model];
            
        }else{
            HomeModel *model = [[HomeModel alloc]init];
            model.source_name = [set stringForColumn:@"source_name"];
            model.ids = [NSNumber numberWithInt:[set intForColumn:@"ids"]];
            model.title = [set stringForColumn:@"title"];
            model.userTitle = [set stringForColumn:@"userTitle"];
            model.link_v2 = [set stringForColumn:@"link_v2"];
            model.summary = [set stringForColumn:@"summary"];
            model.category = [set stringForColumn:@"category"];
            model.style = [set stringForColumn:@"style"];
            model.content = [set stringForColumn:@"content"];
            model.picArr = [NSMutableArray arrayWithArray: [SQLManager dataToArr: [set dataForColumn:@"picArr"]]];
            model.headline_img_tb = [set stringForColumn:@"headline_img_tb"];
            model.images = [SQLManager dataToArr: [set dataForColumn:@"images"]];
            [arr addObject:model];
            
            
        }
        
    }
    return arr;
}

- (void)insertDataWithTag:(NSInteger)tag andHomeModel:(HomeModel *)model{
    NSString *tableName = [self tableNameBy:tag];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (source_name,ids,title,userTitle,link_v2,summary,category,style,content,picArr,headline_img_tb,images) values('%@','%d','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",tableName,model.source_name,model.ids.intValue,model.title,model.userTitle,model.link_v2,model.summary,model.category,model.style,model.content,[SQLManager arrToData:model.picArr],model.headline_img_tb,[SQLManager arrToData:model.images]];
    if (![self.dataBase executeUpdate:sqlStr]) {
        NSLog(@"%@插入失败",tableName);
    }
    
}
- (void)insertDataWithTag:(NSInteger)tag andScrollModel:(ScrollViewModel *)model{
    NSString *tableName = [self tableNameBy:tag];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (picture,custom_title,article_id) values('%@','%@','%@')",tableName,model.picture,model.custom_title,model.article_id];
    if (![self.dataBase executeUpdate:sqlStr]) {
        NSLog(@"%@插入失败",tableName);
    }
    
}
- (void)insertDataWithTag:(NSInteger)tag andFirstPageModel:(FirestPageModel *)model{
    NSString *tableName = [self tableNameBy:tag];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (image,spec) values('%@','%@')",tableName,model.image,model.spec];
    if (![self.dataBase executeUpdate:sqlStr]) {
        NSLog(@"%@插入失败",tableName);
    }
    
}

+ (NSData *)arrToData:(NSArray *)arr{
    //    NSLog(@"%@",arr);
    return [NSKeyedArchiver archivedDataWithRootObject:arr];
    //    return [NSJSONSerialization dataWithJSONObject:@{@"key":arr} options:NSJSONWritingPrettyPrinted error:nil];
}
+ (NSArray *)dataToArr:(NSData *)data{
    
    
    //    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    NSLog(@"%@",arr);
    NSArray *arr = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //           NSLog(@"%@",dic);
    
    return arr;
    
    
}
+ (void)alartLikeShow:(UIViewController *)VC with:(BOOL)ret{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    blurView.frame = [UIScreen mainScreen].bounds;
    blurView.tag = 666;
    [VC.view addSubview:blurView];
    NSString *message;
    if (ret) {
        message = @"已经收藏！";
    }else{
        message = @"收藏成功！";
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [blurView removeFromSuperview];
    }];
    
    [alertVC addAction:act1];
    
    
    [VC presentViewController:alertVC animated:YES completion:nil];
    
}


- (NSString *)tableNameBy:(NSInteger)tag{
    switch (tag) {
        case 1:
            return @"tody";
            break;
        case 2:
            return @"like";
            break;
        case 3:
            return @"scroller";
            break;
        case 0:
            return @"first";
            break;
        default:
            return nil;
            break;
    }
    
    
}



@end
