//
//  MyCollectionViewCell.m
//  CollectionView带编辑状态
//
//  Created by 李东旭 on 16/5/19.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageV];
        self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - 30, self.bounds.size.height - 30, 30, 30)];
        self.myLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.myLabel];

     
    }
    
    return self;
}

@end
