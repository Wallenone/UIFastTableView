# UIFastTableView

[![CI Status](http://img.shields.io/travis/wanjiehuizhaofang/UIFastTableView.svg?style=flat)](https://travis-ci.org/wanjiehuizhaofang/UIFastTableView)
[![Version](https://img.shields.io/cocoapods/v/UIFastTableView.svg?style=flat)](http://cocoapods.org/pods/UIFastTableView)
[![License](https://img.shields.io/cocoapods/l/UIFastTableView.svg?style=flat)](http://cocoapods.org/pods/UIFastTableView)
[![Platform](https://img.shields.io/cocoapods/p/UIFastTableView.svg?style=flat)](http://cocoapods.org/pods/UIFastTableView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

UIFastTableView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UIFastTableView"
```

## Example

NSMutableArray *arrays = [[NSMutableArray alloc]init];
for (int i = 0; i<6; i++) {
[arrays insertObject:MJRandomData atIndex:0];
}

CGRect tbvFrame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height);
//初始化

_tbv = [[EZJFastTableView alloc]initWithFrame:tbvFrame];

//给tableview赋值
// [_tbv setDataArray:arrays];

[_tbv onBuildCell:^(id cellData,NSString *cellIdentifier,NSIndexPath *index) {
UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
cell.userInteractionEnabled = true;
cell.textLabel.text = cellData;
return cell;
}];

//动态改变
[_tbv onChangeCellHeight:^CGFloat(NSIndexPath *indexPath) {

if (indexPath.row==1) {
return 100.0;
}
if (indexPath.row==4) {
return 80.0;
}
return _tbv.rowHeight;
}];



//允许上行滑动
[_tbv onDragUp:^NSArray * (int page) {
return [self loadNewData:page];
}];

//允许下行滑动刷新
[_tbv onDragDown:^{

}];


//设置选中事件 block设置方式
//indexPath  是当前行对象 indexPath.row(获取行数)
//cellData 是当前行的数据

[_tbv onCellSelected:^(NSIndexPath *indexPath, id cellData) {
NSLog(@"click");
}];




## Author

wallen, 910082734@qq.com

## License

UIFastTableView is available under the MIT license. See the LICENSE file for more info.
