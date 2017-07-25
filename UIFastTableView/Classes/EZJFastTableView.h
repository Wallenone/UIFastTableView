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
typedef NSArray* (^DragUpBlock)(int);
typedef void (^DragDownBlock)();
typedef CGFloat (^AutoChangeCellHeightBlock)(id,id);
typedef NSArray*(^TitleForHeaderInSection)(void);
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
 *  动态改变cell的高度
 */
- (void)onChangeCellHeight:(AutoChangeCellHeightBlock)block;


@end




