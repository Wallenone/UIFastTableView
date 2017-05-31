//
//  DemoTableViewController.m
//  SyUtils
//
//  Created by wallen on 15/12/15.
//  Copyright (c) 2015年 wallen. All rights reserved.
//

#import "DemoTableViewController.h"
#import "EZJFastTableView.h"

@interface DemoTableViewController()
@property(nonatomic,strong)EZJFastTableView *tbv;
@end


/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
@implementation DemoTableViewController
- (void)viewDidLoad{
	[super viewDidLoad];
	self.title = @"快速创建TableView";
	self.view.backgroundColor = [UIColor whiteColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
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
   
	[self.view addSubview:_tbv];
}

#pragma mark - 数据处理相关
- (NSMutableArray *)loadNewData:(NSInteger)Page
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (int i = 0; i<10; i++) {
        [arr addObject:MJRandomData];
    }
    return arr;

}


@end
