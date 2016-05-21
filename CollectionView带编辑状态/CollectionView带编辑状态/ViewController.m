//
//  ViewController.m
//  CollectionView带编辑状态
//
//  Created by 李东旭 on 16/5/18.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "ViewController.h"
#import "LDX_EditCollectionView.h"
#import "SDWebImage/UIImageView+WebCache.m"
#import "AFNetworking.h"
#import "MyCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, EditCollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) LDX_EditCollectionView *col;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    
#warning 1. 创建对象, 设置editDelegate代理人
    self.col = [[LDX_EditCollectionView alloc] initWithFrame:CGRectMake(0, 120, 414, 736) collectionViewLayout:layout];
    self.col.editDelegate = self;

#warning 2. 注册自定义CollectionViewCell以及重用池标识
    [self.col registerEditClassForCell:[MyCollectionViewCell class] identifier:@"myCell"];
    
    AFHTTPSessionManager *man = [AFHTTPSessionManager manager];
    [man.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
    [man GET:@"http://c.3g.163.com/nc/article/headline/T1348647909107/0-140.html" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *arr = responseObject[@"T1348647909107"];
        for (NSDictionary *dic in arr) {
            [self.col.dataArray addObject:dic[@"imgsrc"]];
        }
#warning 3.设置数据源 给self.col.dataArray 赋值
        NSLog(@"%ld", self.col.dataArray.count);
        [self.col reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
#warning 4. 根据需求设置cell上选中按钮样式等
    [self.col setSelectButtonProperty:CGRectMake(20, 20, 50, 50) selectYesImage:[UIImage imageNamed:@"Yes.png"] selectNoImage:[UIImage imageNamed:@"No.png"] isCirl:YES alpha:0.7];
    
    [self.view addSubview:self.col];
 
#warning 5. 设置功能按钮(如果用我给你的, 只需要设置位置以及一些属性)
    self.col.selectButton.frame = CGRectMake(0, 0, 100, 100);
    self.col.selectButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.col.selectButton];
    
    self.col.selectAllButton.frame = CGRectMake(150, 20, 100, 100);
    self.col.selectAllButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.col.selectAllButton];
    
    self.col.deleteButton.frame = CGRectMake(300, 20, 100, 100);
    self.col.deleteButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.col.deleteButton];
    
}


#warning 6. 遵守协议, 并实现2个必须实现的协议方法
- (void)collectionCellForItemAtIndexPath:(NSIndexPath *)indexPath cell:(UICollectionViewCell *)cell identifier:(NSString *)identifier
{
  
    MyCollectionViewCell *tCell = (MyCollectionViewCell *)cell;
    tCell.backgroundColor = [UIColor greenColor];
        [tCell.myLabel setText:[NSString stringWithFormat:@"%ld", indexPath.row]];
    NSString *imageU = self.col.dataArray[indexPath.row];
    [tCell.imageV sd_setImageWithURL:[NSURL URLWithString:imageU]];
}

#warning 7. 获取选中的cell的下标, 自己删除对应的数据源.
- (void)getSelectCellData:(NSArray *)cellArr
{
    NSLog(@"%@", cellArr);
}


@end
