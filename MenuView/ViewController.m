//
//  ViewController.m
//  MenuView
//
//  Created by ryhx on 16/2/16.
//  Copyright © 2016年 lay. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
/*系统屏幕的高*/
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
/*系统屏幕的宽*/
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenWidth-90, 120, 80, 40);
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)buttonClick{
    static BOOL type;
    type = !type;
    
    MenuView * mv = [[MenuView alloc] initWithTitleArray:@[@"微信好友",@"朋友圈",@"QQ好友",@"QQ空间",@"微博"] imageArray:@[@"周边商户",@"母婴产品",@"精品零食",@"美味水果",@"休闲旅行"] origin:CGPointMake(kScreenWidth, 160) rowWidth:100 rowHeight:44 Direct:kRightTriangle MenuType:type?kCollectionView:kTableView];
    [self.view addSubview:mv];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
