//
//  EASYTableView.m
//  SyUtils
//
//  Created by wallen on 15/12/15.
//  Copyright (c) 2015年 wallen. All rights reserved.
//

#import "EZJFastTableView.h"


#import "MJRefresh.h"


// objc_msgSend
#define msgSend(...) ((void (*)(void *, SEL, NSObject *))objc_msgSend)(__VA_ARGS__)
#define msgTarget(target) (__bridge void *)(target)

/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@implementation EZJFastTableView
{
    
    NSMutableArray   *arrayDatas;/**<数据源数据*/
    int  currentPage;
    BuildCellBlock buildCellBlock;
    CellSelectedBlock cellSelectedBlock;
    DragUpBlock dragUpBlock;
    DragDownBlock dragDownBlock;
    AutoChangeCellHeightBlock autoChangeCellHeightBlock;
}
//@synthesize customerViewName,columnNumber,reFreshPage;
//@synthesize leftMargin,apartMargin,cellWidth;

- (id)init{
    if (self = [super init]) {
        arrayDatas = [NSMutableArray array];
        //_isSectionStickyHeader = YES;
    }
    return self;
}

#pragma mark - 单行tableview初始化 block回调
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        currentPage=0;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)arr{
    if (arr) {
        arrayDatas=[arr mutableCopy];
    }
}

-(void)onBuildCell:(BuildCellBlock)block{
    if (block) {
        buildCellBlock=block;
    }
}

- (void)onCellSelected:(CellSelectedBlock)block{
    if (block) {
        cellSelectedBlock= block;
    }
}


- (void)onChangeCellHeight:(AutoChangeCellHeightBlock)block{
    if (block) {
        autoChangeCellHeightBlock = block;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (autoChangeCellHeightBlock) {
        return autoChangeCellHeightBlock(indexPath);
    }
    return self.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!arrayDatas) {
        return 0;
    }
    return arrayDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"cellIdentifierCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell==nil){
        cell=buildCellBlock([arrayDatas objectAtIndex:indexPath.row],cellIdentifier,indexPath);
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:_sectionHeaderView];
	return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
 }*/


#pragma mark - tableView选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNotification *notification =[NSNotification notificationWithName:@"userdata_event" object:nil userInfo:@{@"name":@"click"}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    if (cellSelectedBlock) {
        cellSelectedBlock(indexPath,[arrayDatas objectAtIndex:indexPath.row]);
    }
   //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 去掉UItableview headerview黏性
/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
	if (!_isSectionStickyHeader) {
 CGFloat sectionHeaderHeight = 40;
 if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
 scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
 }
 else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
 scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
 }
	}
	
 }*/

- (void)onDragUp:(DragUpBlock)block{ //上拉加载数据
    if (block) {
        dragUpBlock=block;
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self.mj_footer endRefreshing];
            currentPage=currentPage+1;
            NSArray *cellDatas =dragUpBlock(currentPage);
            
            if (cellDatas.count>0) {
                [arrayDatas addObjectsFromArray:cellDatas];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
            }else{
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}

- (void)onDragDown:(DragDownBlock)block{
    //下拉刷新
    if (block) {
        dragDownBlock=block;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.onTableViewDidScroll ? self.onTableViewDidScroll(self, scrollView.contentOffset) : nil;
}

@end
