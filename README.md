# Register-Login-PHP
暂时只支持一种Cell类型, 并且在iOS8以上,  封装了一个自定义可编辑Cell的UICollectionView, 内部逻辑已经完全封装好了, 用户只需要用这个UICollectionView对象, 自己创建UICollectionViewCell, 还可以自己设置选中和未选中按钮的图片, 尺寸, 透明度, 圆不圆形等, 当然了, 也可以利用接口, 自己去写3个按钮. 或者看我的源码自己去修改相应功能! 第一次发作品. 如有不足还望指教!!

![](http://upload-images.jianshu.io/upload_images/1400788-3a4e213c38b7bb71.gif?imageMogr2/auto-orient/strip)

#具体用法: 
<pre>
//warning 1. 创建对象, 设置editDelegate代理人
self.col = [[LDX_EditCollectionView alloc] initWithFrame:CGRectMake(0, 120, 414, 736) collectionViewLayout:layout];
self.col.editDelegate = self;
</pre>
<pre>
//warning 2. 注册自定义CollectionViewCell以及重用池标识
[self.col registerEditClassForCell:[MyCollectionViewCell class] identifier:@"myCell"];
</pre>
<pre>
//warning 3. 设置数据源
[self.col.dataArray addObject:dic[@"imgsrc"]];
</pre>
<pre>
//warning 4. 根据需求设置cell上选中按钮样式等
[self.col setSelectButtonProperty:CGRectMake(20, 20, 50, 50) selectYesImage:[UIImage imageNamed:"Yes.png"] selectNoImage:[UIImage imageNamed:"No.png"] isCirl:YES alpha:0.7];
</pre>
<pre>
//warning 5. 设置功能按钮(如果用我给你的, 只需要设置位置以及一些属性)

    self.col.selectButton.frame = CGRectMake(0, 0, 100, 100);
    self.col.selectButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.col.selectButton];

    self.col.selectAllButton.frame = CGRectMake(150, 20, 100, 100);
    self.col.selectAllButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.col.selectAllButton];
   
    self.col.deleteButton.frame = CGRectMake(300, 20, 100, 100);
    self.col.deleteButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.col.deleteButton];
</pre>
<pre>
//warning 6. 遵守协议, 并实现2个必须实现的协议方法
- (void)collectionCellForItemAtIndexPath:(NSIndexPath *)indexPath cell(UICollectionViewCell *)cell identifier!(NSString *)identifier
{
    MyCollectionViewCell *tCell = (MyCollectionViewCell *)cell;
    tCell.backgroundColor = [UIColor greenColor];
     [tCell.myLabel setText:[NSString stringWithFormat:"%ld", indexPath.row]];
    NSString *imageU = self.col.dataArray[indexPath.row];
   [tCell.imageV sd_setImageWithURL:[NSURL URLWithString:imageU]];
}
</pre>
<pre>
//warning 7. 获取选中的cell的下标, 自己删除对应的数据源.
- (void)getSelectCellData!(NSArray *)cellArr
{
    NSLog(@"%@", cellArr);
}
</pre>
