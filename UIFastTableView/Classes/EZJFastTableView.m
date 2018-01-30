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


@interface EZJFastTableView(){
    BOOL _drogUpState;  //是否开启上啦加载
}
@property(nonatomic,strong)NSMutableArray   *arrayDatas;/**<数据源数据*/

@end

@implementation EZJFastTableView
{
    
    
    int  currentPage;
    BuildCellBlock buildCellBlock;
    CellSelectedBlock cellSelectedBlock;
    DragUpBlock dragUpBlock;
    DragDownBlock dragDownBlock;
    AutoChangeCellHeightBlock autoChangeCellHeightBlock;
    Cellediting cellediting;
    ScollViewDidBlock scollViewDidBlock;
    CelleditArrBlock celleditArrBlock;
}
//@synthesize customerViewName,columnNumber,reFreshPage;
//@synthesize leftMargin,apartMargin,cellWidth;

- (id)init{
    if (self = [super init]) {
        _drogUpState=NO;
        self.arrayDatas = [NSMutableArray array];
        //_isSectionStickyHeader = YES;
    }
    return self;
}

-(NSMutableArray *)arrayDatas{
    if (!_arrayDatas) {
        _arrayDatas=[NSMutableArray array];
    }
    
    return _arrayDatas;
}

#pragma mark - 单行tableview初始化 block回调
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        currentPage=0;
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (void)setDataArray:(NSArray *)arr{
    if (arr) {
        self.arrayDatas=[arr mutableCopy];
    }
}

-(void)updateData:(NSArray *)arr{
    if (arr) {
        [self.arrayDatas removeAllObjects];
        self.arrayDatas=[arr mutableCopy];
        [self reloadData];
    }
}

- (void)insertData:(id)data{
    if (data) {
        [self.arrayDatas addObject:data];
        [self reloadData];
    }
}

- (void)addData:(NSArray *)arr{
    if (_drogUpState) {
        if (arr.count>0) {
            for (id cellData in arr) {
                [self.arrayDatas addObject:cellData];
            }
            [self reloadData];
        }
        //            else{
        //            [self.mj_footer endRefreshingWithNoMoreData];
        //        }
    }
    
}

- (void)addContentData:(NSArray *)arr{
    if (arr.count>0) {
        for (id cellData in arr) {
            [self.arrayDatas addObject:cellData];
        }
        [self reloadData];
    }
}
-(NSArray *)getDataArray{
    return self.arrayDatas;
}

-(void)deleteCell:(NSArray *)arr{
    for (NSIndexPath *indexPath in arr) {
        [self.arrayDatas removeObjectAtIndex:indexPath.row];
    }
    
    [self deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationFade];
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

- (void)onCellediting:(Cellediting)block{
    if (block) {
        cellediting=block;
    }
}

- (void)onCellediting:(Cellediting)block withCelleditBlock:(CelleditArrBlock)arrBlock{
    if (block) {
        cellediting=block;
    }
    if (arrBlock) {
        celleditArrBlock=arrBlock;
    }
}

- (void)scrollToTop:(BOOL)animated {
    [self setContentOffset:CGPointMake(0,0) animated:animated];
}


- (void)scrollToBottom:(BOOL)animated {
    NSUInteger sectionCount = [self numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [self numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {0, rowCount-1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
                                animated:animated];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (autoChangeCellHeightBlock) {
        return autoChangeCellHeightBlock(indexPath,[self.arrayDatas objectAtIndex:indexPath.row]);
    }
    return self.rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.arrayDatas) {
        return 0;
    }
    return self.arrayDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"cellIdentifierCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell==nil){
        cell=buildCellBlock([self.arrayDatas objectAtIndex:indexPath.row],cellIdentifier,indexPath);
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(cellediting){
        return YES;
    }else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (cellediting) {
            cellediting(indexPath,[self.arrayDatas objectAtIndex:indexPath.row]);
        }
        [self.arrayDatas removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (celleditArrBlock) {
        return celleditArrBlock(indexPath,[self.arrayDatas objectAtIndex:indexPath.row]);
    }
    
    return @[];
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
        cellSelectedBlock(indexPath,[self.arrayDatas objectAtIndex:indexPath.row]);
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
            if (dragUpBlock) {
                dragUpBlock(currentPage);
            }
            
            _drogUpState=YES;
            //            if (cellDatas.count>0) {
            //                [self.arrayDatas addObjectsFromArray:cellDatas];
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [self reloadData];
            //                });
            //            }else{
            //                [self.mj_footer endRefreshingWithNoMoreData];
            //            }
        }];
    }
}

- (void)onDragDown:(DragDownBlock)block{
    //下拉刷新
    if (block) {
        dragDownBlock=block;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.mj_header endRefreshing];
            [self.mj_footer endRefreshing];
            if (dragDownBlock) {
                dragDownBlock();
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadData];
            });
        }];
    }
}

-(void)onScrollDid:(ScollViewDidBlock)block{
    scollViewDidBlock=block;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.onTableViewDidScroll ? self.onTableViewDidScroll(self, scrollView.contentOffset) : nil;
    if (scollViewDidBlock) {
        scollViewDidBlock(scrollView);
    }
}

- (void)noMoreData{
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end

