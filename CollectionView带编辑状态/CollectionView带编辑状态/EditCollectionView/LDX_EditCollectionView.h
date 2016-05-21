//
//  EditCollectionView.h
//  CollectionView带编辑状态
//
//  Created by 李东旭 on 16/5/18.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义可编辑的UICollectionView
 *  注:(1) 暂时只支持注册一种Cell
 *    (2) 可使用我设置好的button, 或者自己调用2个BOOL值进行逻辑判断
 */

@protocol EditCollectionViewDelegate <NSObject>

/**
 *  获取Cell的方法, 在这个协议方法里你可以根据自定义cell获取自己自定义cell里赋值数据的方法
 *
 *  @param indexPath indexpath
 *  @param cell      cell
 */
- (void)collectionCellForItemAtIndexPath:(NSIndexPath *)indexPath cell:(UICollectionViewCell *)cell identifier:(NSString *)identifier;

/**
 *  获取用户选择了哪些cell
 *
 *  @param cellArr 选择的cell的indexpath.row
 */
- (void)getSelectCellData:(NSArray *)cellArr;

@end

@interface LDX_EditCollectionView : UICollectionView

// 必须实现下面这些
/**
 *  数据源(注: 请传递过来可变数组)
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

// 设置代理人, 实现协议方法获取cell
@property (nonatomic, assign) id<EditCollectionViewDelegate> editDelegate;

// 注册cell类型和重用池标识
- (void)registerEditClassForCell:(Class)cla identifier:(NSString *)identifier;

// 设置选择按钮样式
- (void)setSelectButtonProperty:(CGRect)frame selectYesImage:(UIImage *)yesImage selectNoImage:(UIImage *)noImage isCirl:(BOOL)isCirl alpha:(CGFloat)alphaD;

// 根据需要可选实现
#warning 如果外部不想自己写逻辑, 那么可以用我给你提供的button(你只需要设置frame, 添加到指定视图上)
// 设置选择按钮(开始编辑)或者取消
@property (nonatomic, strong) UIButton *selectButton;

// 设置全选或者取消全选
@property (nonatomic, strong) UIButton *selectAllButton;

// 设置删除按钮
@property (nonatomic, strong) UIButton *deleteButton;

// 编辑状态 (YES代表开启, NO代表关闭)
@property (nonatomic, assign) BOOL isCanEdit;

// 是否全选 (YES代表全选, NO代表取消全选)
@property (nonatomic, assign) BOOL isSelectAll;

@end
