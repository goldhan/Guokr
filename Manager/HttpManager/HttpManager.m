//
//  HttpManager.m
//  果壳精选
//
//  Created by 韩金 on 16/7/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager
+(instancetype)ShareInstance{
    static HttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpManager alloc]init];
    });
    return manager;
}

- (void)getDataFromNet:(NSInteger)tags andSuccess:(successBlock)succ andFail:(fail)fail{
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    
    NSString *url = [self getUrlWith:tags];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//       NSLog(@"%@",downloadProgress);
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       succ(responseObject);
       [act stopAnimating];
       act.hidesWhenStopped = YES;
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       fail(error);
   }];
 
    
    
}
- (void)getHtmlDataFromNet:(NSString *)url andSuccess:(successBlock)succ andFail:(fail)fail {
   
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
            succ(data);
            [act stopAnimating];
            act.hidesWhenStopped = YES;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
            }];
            
            
        }else{
            NSLog(@"%@",error);
        }
        
        
    }];
    [task resume];

}

-(void)getDataFromNet:(NSInteger)tags andPage_id:(NSInteger)page andType:(NSString *)type andSuccess:(successBlock)succ andFail:(fail)fail{
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    NSString *url;
    if (tags != 2 ) {
        url = [NSString stringWithFormat:[self getUrlWith:tags],page];
    }else{
        url = [NSString stringWithFormat:[self getUrlWith:tags],page,type];
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //       NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succ(responseObject);
        [act stopAnimating];
        act.hidesWhenStopped = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];

    
    
}


+ (void)alartShow:(UIViewController *)VC andAct1Block:(act1)btn1 andAct2Block:(act2)btn2{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    blurView.frame = [UIScreen mainScreen].bounds;
    blurView.tag = 666;
    [VC.view addSubview:blurView];
    
    
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"网络错误" message:@"是否重新刷新？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [blurView removeFromSuperview];
        if (btn1) {
            
            btn1();
        }
        
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [blurView removeFromSuperview];
        if (btn2) {
            
            btn2();
        }
        
    }];
    
    [alertVC addAction:act1];
    [alertVC addAction:act2];
    
    [VC presentViewController:alertVC animated:YES completion:nil];
    
}
+ (void)alartShow:(UIViewController *)VC{
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    
    blurView.frame = [UIScreen mainScreen].bounds;
    blurView.tag = 666;
    [VC.view addSubview:blurView];
    
    NSInteger size = [[SDImageCache sharedImageCache]getSize];
    NSString *str = [NSString stringWithFormat: @"图片已经缓存了%.1fMB,是否清理？",size / 1024.0 / 1024];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"图片缓存" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [blurView removeFromSuperview];
        
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [blurView removeFromSuperview];
        [[SDImageCache sharedImageCache] clearDisk];
        
    }];
    
    [alertVC addAction:act1];
    [alertVC addAction:act2];
    
    [VC presentViewController:alertVC animated:YES completion:nil];
    
}


- (NSString *)getUrlWith:(NSInteger)tag{
    switch (tag) {
        case 1:
            return kToday;
            break;
        case 2:
            return kOther;
            break;
        case 11:
            return kScrolVUrl;
            break;
        case 12:
            return kScrolVDetail;
            break;
        case 21:
            return kDetail;
            break;
        case 22:
            return kRecommend;
            break;
        case 0:
            return kFirstPage;
            break;
        default:
            return @"";
            break;
    }
}


@end
