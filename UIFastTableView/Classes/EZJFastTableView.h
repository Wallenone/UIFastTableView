//
//  EASYTableView.h
//  SyUtils
//
//  Created by wallen on 15/12/15.
//  Copyright (c) 2015年 wallen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EZJFastTableView.h"



typedef UITableViewCell * (^BuildCellBlock)(id,NSString *,NSIndexPath *);
typedef void (^CellSelectedBlock)(id,id);
typedef void (^DragUpBlock)(int);
typedef void (^DragDownBlock)(void);
typedef CGFloat (^AutoChangeCellHeightBlock)(id,id);
typedef NSArray*(^TitleForHeaderInSection)(void);
typedef void (^Cellediting)(NSIndexPath *,id);
typedef void (^ScollViewDidBlock)(UIScrollView *);
typedef NSArray *(^CelleditArrBlock) (NSIndexPath *,id);
@interface EZJFastTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) void(^onTableViewDidScroll)(EZJFastTableView *tableView, CGPoint contentOffset);


//@property (nonatomic,strong) NSString  *customerViewName;/**<自定义view名称*/

//@property (nonatomic,strong) NSArray *cellHeightArrays;/**cell动态高度数据*/

//@property (assign, nonatomic) NSInteger reFreshPage;   //刷行页数





//@property (nonatomic,assign) NSInteger columnNumber;/**<列数*/
//@property (nonatomic,assign) CGFloat   leftMargin;/**<左边距*/
//@property (nonatomic,assign) CGFloat   apartMargin;/**<中间间距*/
//@property (nonatomic,assign) CGFloat   cellWidth;//**<cell的宽度/

//@property (nonatomic,assign) BOOL  isSectionStickyHeader;/**<section是否黏住状况，是否冻结*/


/**
 *  初始化单行tableView block回调
 *  frame,customerViewName自定义view的名称，target设置data的目标，action执行的方法
 */
- (id)initWithFrame:(CGRect)frame;
/**
 *  上行滑动刷新block
 */

- (void)onDragUp:(DragUpBlock)block;

/**
 *  下行滑动刷新block
 */
- (void)onDragDown:(DragDownBlock)block;

/**
 *  创建cell block
 */

- (void)onBuildCell:(BuildCellBlock)block;

/**
 *  点击cell block
 */
- (void)onCellSelected:(CellSelectedBlock)block;

/**
 *  初始化赋值arr
 */
- (void)setDataArray:(NSArray *)arr;

/**
 *  得到当前所有数据
 */
-(NSArray *)getDataArray;
/**
 *  动态改变cell的高度
 */
- (void)onChangeCellHeight:(AutoChangeCellHeightBlock)block;
//更新数据
- (void)updateData:(NSArray *)arr;

//插入数据
- (void)insertData:(id)data;
//用在上啦加载中
- (void)addData:(NSArray *)arr;

//用在普通加数据上
- (void)addContentData:(NSArray *)arr;

//右滑动删除
- (void)onCellediting:(Cellediting)block;

//右滑动删除  arrBlock菜单内容
- (void)onCellediting:(Cellediting)block withCelleditBlock:(CelleditArrBlock)arrBlock;

//滚动到顶部
- (void)scrollToTop:(BOOL)animated;

//滚动到底部
- (void)scrollToBottom:(BOOL)animated;

//滑动回调
-(void)onScrollDid:(ScollViewDidBlock)block;

- (void)noMoreData;

//手动删除某一行或者多行cell
-(void)deleteCell:(NSArray *)arr;
@end




