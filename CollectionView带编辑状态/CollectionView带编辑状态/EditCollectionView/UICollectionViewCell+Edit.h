//
//  UICollectionViewCell+Edit.h
//  CollectionView带编辑状态
//
//  Created by 李东旭 on 16/5/18.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UICollectionViewCell (Edit)

@property (nonatomic, strong) UIButton *editButton;

// cell 滑动时调取, 重新设置cell的按钮的样式
- (void)isSelectImageForButton:(UIButton *)button isShow:(BOOL)isShow;

@end



