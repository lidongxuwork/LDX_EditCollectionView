//
//  EditCollectionView.m
//  CollectionView带编辑状态
//
//  Created by 李东旭 on 16/5/18.
//  Copyright © 2016年 李东旭. All rights reserved.
//

#import "LDX_EditCollectionView.h"
#import "UICollectionViewCell+Edit.h"

@interface LDX_EditCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSString *_myIdentifier;
    CGRect _editButtonFrame;
    UIImage *_yesImage;
    UIImage *_noImage;
    BOOL _isCirl;
    CGFloat _alphaD;
}
// 保存的用户选择的indexpath.row
@property (nonatomic, strong) NSMutableArray *selectArr;
@end

@implementation LDX_EditCollectionView
@synthesize selectButton = _selectButton;
@synthesize selectAllButton = _selectAllButton;
@synthesize deleteButton = _deleteButton;
#pragma mark - 系统方法
- (id)valueForKey:(NSString *)key
{
    if ([key isEqualToString:@"selectArr"]) {
        static dispatch_once_t onceToken;
        __block LDX_EditCollectionView *v = self;
        dispatch_once(&onceToken, ^{
            v.selectArr = [NSMutableArray array];
        });
        return self.selectArr;
    }
    
    return [super valueForKey:key];
}

#pragma mark - setter方法
- (void)setIsSelectAll:(BOOL)isSelectAll
{
    _isSelectAll = isSelectAll;
    NSMutableArray *arr = [self valueForKey:@"selectArr"];
    [arr removeAllObjects];
    // 是否开启编辑模式, 数据源是否有数据, 是否开启全选
    if (_isCanEdit && self.dataArray.count != 0 && isSelectAll) {
        
        for (int i = 0; i < self.dataArray.count; i++) {
            [arr addObject:@(100000 + i)];
        }
        
        // 发送改变按钮样式
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditButton" object:@"all"];
    }
    else {
        // 取消所有模式
        [arr removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditButton" object:@"chancelAll"];
    }
}

- (void)setIsCanEdit:(BOOL)isCanEdit
{
    _isCanEdit = isCanEdit;
    
    if (isCanEdit) {
        // 显示编辑按钮
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditButton" object:@"show"];
        [self.selectArr removeAllObjects];
    }
    else {
        // 隐藏编辑按钮
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditButton" object:nil];
    }
}

#pragma mark - 按钮的setter, getter方法
- (void)setSelectButton:(UIButton *)selectButton
{
    _selectButton = [self selectButton];
}

- (UIButton *)selectButton
{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    return _selectButton;
}

- (void)setSelectAllButton:(UIButton *)selectAllButton
{
    _selectAllButton = [self selectAllButton];
}

- (UIButton *)selectAllButton
{
    if (_selectAllButton == nil) {
        _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllButton addTarget:self action:@selector(selectAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        _selectAllButton.enabled = NO;
    }
    
    return _selectAllButton;
}

- (void)setDeleteButton:(UIButton *)deleteButton
{
    _deleteButton = [self deleteButton];
}

- (UIButton *)deleteButton
{
    if (_deleteButton == nil) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    
    return _deleteButton;
}



#pragma mark - ButtonAction
- (void)selectButtonAction:(UIButton *)bu
{
    // 发送通知, 设置选中按钮一些信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditButton" object:nil userInfo:@{@"frame":[NSValue valueWithCGRect:_editButtonFrame], @"yesImage":_yesImage, @"noImage":_noImage, @"isCirl":@(_isCirl), @"alphaD":@(_alphaD)}];
    
    bu.selected = !bu.selected;
    if (bu.selected) {
        self.isCanEdit = YES;
        self.selectAllButton.enabled = YES;
    }
    else {
        self.isCanEdit = NO;
        self.selectAllButton.enabled = NO;
        // 设置全选按钮恢复初始值
        [self.selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
        self.isSelectAll = NO;
        self.selectAllButton.selected = NO;
        
    }
    
    bu.selected ? [bu setTitle:@"取消" forState:UIControlStateNormal] : [bu setTitle:@"编辑" forState:UIControlStateNormal];
}

- (void)selectAllButtonAction:(UIButton *)bu {
    
    bu.selected = !bu.selected;
    if (bu.selected) {
        self.isSelectAll = YES;
    }
    else {
        self.isSelectAll = NO;
    }
    bu.selected ? [bu setTitle:@"取消" forState:UIControlStateNormal] : [bu setTitle:@"全选" forState:UIControlStateNormal];
}

- (void)deleteButtonAction:(UIButton *)bu{
    
    if (self.selectArr.count != 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            // 调用删除cell的方法
            [self realyDelete];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        // 获取CollectionView所在的VC, 好弹出alert
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                UIViewController *v = (UIViewController *)nextResponder;
                [v presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

// 删除cell
- (void)realyDelete
{
    [self.selectButton setTitle:@"编辑" forState:UIControlStateNormal];
    
    _selectButton.selected = !_selectButton.selected;
    self.isCanEdit = NO;
    
    [self.editDelegate getSelectCellData:[self.selectArr mutableCopy]];
    
    // 删除数据
    if (self.selectArr.count != 0) {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        for (NSNumber *num in self.selectArr) {
            // 保存要删除数据的下角标
            [set addIndex:([num intValue] - 100000)];
        }
        
        // 对应删除数据源数据
        [self.dataArray removeObjectsAtIndexes:set];
        
        [self.selectArr removeAllObjects];
        // 刷新collectionView
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
}


// 初始化
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.dataArray = [NSMutableArray array];
    
    return self;
}

// 设置选中按钮一些属性
- (void)setSelectButtonProperty:(CGRect)frame selectYesImage:(UIImage *)yesImage selectNoImage:(UIImage *)noImage isCirl:(BOOL)isCirl alpha:(CGFloat)alphaD
{
    _editButtonFrame = frame;
    _yesImage = yesImage;
    _noImage = noImage;
    // 防止字典里有nil从而crash
    if (_yesImage == nil) {
        _yesImage = [UIImage imageNamed:@" "];
    }
    if (_noImage == nil) {
        _noImage = [[UIImage alloc] init];
    }
    
    _isCirl = isCirl;
    _alphaD = alphaD;
    
}

// 注册重用池
- (void)registerEditClassForCell:(Class)cla identifier:(NSString *)identifier
{
    [self registerClass:cla forCellWithReuseIdentifier:identifier];
    _myIdentifier = identifier;
}

#pragma mark - CollectionView Delegate 方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_myIdentifier forIndexPath:indexPath];
    
    cell.editButton.tag = indexPath.row + 100000;
    [cell isSelectImageForButton:cell.editButton isShow:self.isCanEdit];
    
    // 把cell等传递出去
    [self.editDelegate collectionCellForItemAtIndexPath:indexPath cell:cell identifier:_myIdentifier];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


@end
