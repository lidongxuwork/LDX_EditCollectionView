//
//  UICollectionViewCell+Edit.m
//  CollectionView带编辑状态
//
//  Created by 李东旭 on 16/5/18.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "UICollectionViewCell+Edit.h"
#import "LDX_EditCollectionView.h"
#import <objc/objc-runtime.h>

const char editButtonKey;
const char selectArrKey;



@implementation UICollectionViewCell (Edit)

UIImage *_yesImage;
UIImage *_noImage;

+ (void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getInstanceMethod([self class], @selector(initWithFrame:));
        Method newMethod = class_getInstanceMethod([self class], @selector(initMyWithFrame:));
        // 交换系统方法实现
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

/**
 *  自己实现初始化方法(目的:给每个cell添加个通知和一个button)
 *
 *  @param frame frame
 *
 *  @return cell
 */
- (instancetype)initMyWithFrame:(CGRect)frame
{
    self = [self initMyWithFrame:frame];
    
    // 注册通知, 在按钮状态改变发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEditButton:) name:@"changeEditButton" object:nil];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(0, 0, 20, 20);
    // 默认是未选中按钮状态
    [self.editButton setBackgroundImage:_noImage forState:UIControlStateNormal];
    self.editButton.selected = NO;
    [self.editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.hidden = YES; // 先不显示编辑按钮
    [self.contentView addSubview:self.editButton];
    
    return self;
}

/**
 *  按钮收到通知触发方法
 *
 *  @param noti noti
 */
- (void)changeEditButton:(NSNotification *)noti
{
    // 显示所有编辑按钮
    if ([noti.object isEqualToString:@"show"]) {
        self.editButton.hidden = NO;
        [self.contentView bringSubviewToFront:self.editButton];
    }
    // 选中所有cell
    else  if ([noti.object isEqualToString:@"all"]){
        self.editButton.selected = YES;
    }
    // 取消选中所有cell
    else if ([noti.object isEqualToString:@"chancelAll"]){
        //        self.editButton.hidden = YES;
        self.editButton.selected = NO;
    }
    else {
        self.editButton.hidden = YES;
    }
    if (noti.userInfo) {
        // 获取frame和图片以及透明度圆角
        CGRect rect = [noti.userInfo[@"frame"] CGRectValue];
        _yesImage = noti.userInfo[@"yesImage"];
        _noImage = noti.userInfo[@"noImage"];
        BOOL isCirl = [noti.userInfo[@"isCirl"] boolValue];
        CGFloat alphaD = [noti.userInfo[@"alphaD"] floatValue];
        
        self.editButton.frame = rect;
        self.editButton.alpha = alphaD;
        if (isCirl) {
            self.editButton.layer.masksToBounds = YES;
            self.editButton.layer.cornerRadius = self.editButton.frame.size.width / 2;
        }
        else {
            self.editButton.layer.cornerRadius = 0;
        }
    }
    
    // 根据选没选中属性设置图片
    self.editButton.selected ? [self.editButton setBackgroundImage:_yesImage forState:UIControlStateNormal] : [self.editButton setBackgroundImage:_noImage forState:UIControlStateNormal];
}

/**
 *  按钮点击事件
 *
 *  @param button button
 */
- (void)editButton:(UIButton *)button
{
    // 拿到父类CollectionView对象就能访问数组
    NSMutableArray *arr = [self.superview valueForKey:@"selectArr"];
    
    if (button.selected) {// 如果当前是选中状态应该改变成未选中图片
        [button setBackgroundImage:_noImage forState:UIControlStateNormal];
        [arr removeObject:@(button.tag)];
    } else {
        [button setBackgroundImage:_yesImage forState:UIControlStateNormal];
        [arr addObject:@(button.tag)];
    }
    
    button.selected = !button.selected;
}

// 滑动时触发方法
- (void)isSelectImageForButton:(UIButton *)button isShow:(BOOL)isShow
{
    // 判断数组里有没有这个cell, 设置button图片标记
    NSMutableArray *arr = [self.superview valueForKey:@"selectArr"];
    if ([arr containsObject:@(button.tag)]) {
        [button setBackgroundImage:_yesImage forState:UIControlStateNormal];
    } else {
        [button setBackgroundImage:_noImage forState:UIControlStateNormal];
    }
    
    // 根据isShow来设置每个button是否显示
    // 外面设置YES代表显示, 那么hidden就得等于NO
    self.editButton.hidden = !isShow;
}

- (void)setEditButton:(UIButton *)editButton
{
    objc_setAssociatedObject(self, &editButtonKey, editButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIButton *)editButton
{
    return objc_getAssociatedObject(self, &editButtonKey);
}

@end
