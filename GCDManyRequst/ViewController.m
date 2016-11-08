//
//  ViewController.m
//  GCDManyRequst
//
//  Created by ekhome on 16/11/8.
//  Copyright © 2016年 xiaofei. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
@interface ViewController ()
{
    dispatch_semaphore_t semaphore;
}
@end

@implementation ViewController
static AFHTTPSessionManager *manager = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
   semaphore = dispatch_semaphore_create(0);
    [self initData];
}


-(void)initData{
//    创建信号质量
    
//    创建全局并行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //dispatch_queue_t queue = dispatch_queue_create("chuanxing", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
//       请求1
        [self test];
    });
    dispatch_group_async(group, queue, ^{
//       请求2
        [self test3];
    });
    
    dispatch_group_async(group, queue, ^{
//       请求3
        [self test2];
    });
    
    

    

    
    
    
    dispatch_group_notify(group, queue, ^{
//        三个请求的等待信号
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
      NSLog(@"完成了");
    });
}

-(void)test{
     NSLog(@"第一次请求");
    dispatch_semaphore_signal(semaphore);//1
}


-(void)test2{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"phone":@"18611996469"}];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [dic setValue:identifierForVendor forKey:@"clientNo"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-access-id"];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-signature"];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:10];

     [manager POST:@"http://192.168.231.105:8888/zdcx/customer/sendMsgC" parameters:[dic copy]progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       NSLog(@"第三次请求");
        dispatch_semaphore_signal(semaphore);//1
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"第三次请求");
        dispatch_semaphore_signal(semaphore);//1
    }];

}





-(void)test3{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"phone":@"18611996469",@"code":@"8888"}];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [dic setValue:identifierForVendor forKey:@"clientNo"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-access-id"];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-signature"];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:10];
    
    
    
    
    for (int i = -1000000; i<1000000; i++)
    {
        for (int i =0; i<1000; i++)
        {
            
        }
    }
    
    
    
    [manager POST:@"http://192.168.231.105:8888/custom/sendMsgC" parameters:[dic copy]progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"第二次请求");
        dispatch_semaphore_signal(semaphore);//1
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"第二次请求");
        dispatch_semaphore_signal(semaphore);//1
    }];
    
}






- (AFHTTPSessionManager *)sharedAFManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html", @"application/json",  @"text/javascript", @"text/plain", nil];
    });
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-access-id"];
    [manager.requestSerializer setValue:@"123" forHTTPHeaderField:@"x-signature"];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setTimeoutInterval:20];
    return manager;
}



/**
 
 首先创建并行队列，创建队列组，将队列和需要处理的网络请求分别添加到组中，当组中所有队列处理完事件后调用dispatch_group_notify，我们需要在里边处理事件。由于队列在处理网络请求时将”发送完一个请求”作为事件完成的标记（此时还未获得网络请求返回数据），所以在这里需要用信号量进行控制，在执行dispatch_group_notify前发起信号等待（三次信号等待，分别对应每个队列的信号通知），在每个队列获取到网络请求返回数据时发出信号通知。这样就能完成需求中的要求。
 
 如果需求中改为：同时存在A,B,C三个任务，要求ABC依次进行处理，当上一个完成时再进行下一个任务，当三个任务都完成时再处理事件。这时只需要将队列改为串行队列即可（不在需要信号量控制）。
 
 */





@end
