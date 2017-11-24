//
//  IndexViewController.m
//  ChineseGirl
//
//  Created by wallen on 2017/8/8.
//  Copyright © 2017年 wanjiehuizhaofang. All rights reserved.
//

#import "IndexViewController.h"
#import "BHInfiniteScrollView.h"
#import "EZJFastTableView.h"
#import "MyIndexViewController.h"
#import "CGFriendsAddViewController.h"
#import "EZJFastTableView.h"
#import "WSCollectionHeaderCell.h"
#import "CGIndexModel.h"
#import "WSCollectionCell.h"
#import "XLVideoCell.h"
#import "XLVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "CGVideoViewController.h"
@interface IndexViewController ()<BHInfiniteScrollViewDelegate,HzfNavigationBarDelegate,UIScrollViewDelegate>{
    NSIndexPath *_indexPath;
    
}
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIButton *rightIcon;
@property(nonatomic,strong)UIImageView *titleImg;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *lineView;
@property (nonatomic, strong)UIView* infinitePageView;
@property (nonatomic, strong)UIImageView *infiniteImgView;
@property(nonatomic,strong)EZJFastTableView *tbv;
@property(nonatomic,strong)XLVideoPlayer *player;
@end

@implementation IndexViewController

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.player destroyPlayer];
    self.player = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor getColor:@"EEEEEE"];
    
    [self setHeaderView];
    [self addSubViews];
    
}

-(void)setHeaderView{
    [self.view addSubview:self.headerView];
    // [self.headerView addSubview:self.titleImg];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.rightIcon];
    [self.view addSubview:self.lineView];
}



- (void)addFriend{
    CGFriendsAddViewController *addVC=[[CGFriendsAddViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:NO];
}

-(void)addSubViews{
    [self.view addSubview:self.tbv];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index {
    //NSLog(@"did scroll to index %ld", index);
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index {
    //NSLog(@"did select item at index %ld", index);
}
-(UIView *)headerView{
    if (!_headerView) {
        _headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 64*SCREEN_RADIO)];
        _headerView.backgroundColor=[UIColor whiteColor];
    }
    
    return _headerView;
}

-(UIButton *)rightIcon{
    if (!_rightIcon) {
        _rightIcon=[[UIButton alloc] initWithFrame:CGRectMake(screen_width-32*SCREEN_RADIO, 32*SCREEN_RADIO, 22*SCREEN_RADIO, 22*SCREEN_RADIO)];
        [_rightIcon setImage:[UIImage imageNamed:@"addFriends"] forState:UIControlStateNormal];
        [_rightIcon addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightIcon;
}

-(UIImageView *)titleImg{
    if (!_titleImg) {
        _titleImg=[[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-47*SCREEN_RADIO, 32*SCREEN_RADIO, 94*SCREEN_RADIO, 27*SCREEN_RADIO)];
        _titleImg.image=[UIImage imageNamed:@"BitmapIcon"];
    }
    return _titleImg;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 32*SCREEN_RADIO, screen_width, 30*SCREEN_RADIO)];
        _titleLabel.text=@"ChineseGirl";
        _titleLabel.textColor=[UIColor getColor:@"1D1D1B"];
        _titleLabel.font=[UIFont fontWithName:@"Billabong" size:25*SCREEN_RADIO];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame)-1, screen_width, 1)];
        _lineView.backgroundColor=[UIColor getColor:@"FAFAFA"];
    }
    
    return _lineView;
}

-(void)getCollectionData:(NSInteger)page{
    NSMutableArray *array = [CGIndexModel reloadTableWithRangeFrom:page*10 rangeTLenth:10];
    if (array.count>0) {
        [self.tbv addContentData:array];
    }else{
        [self.tbv noMoreData];
    }
}

-(CGFloat)getCellHeightWithModel:(CGIndexModel*)model{
    if([model.type integerValue]==1){
        CGFloat _height=56*SCREEN_RADIO;
        if (model.pictureBigs.count==1 || model.pictureBigs.count==2) {
            _height+=284*SCREEN_RADIO;
        }else if(model.pictureBigs.count==4){
            _height+=284*SCREEN_RADIO-6*SCREEN_RADIO;
        }else if(model.pictureBigs.count==3){
            _height+=(screen_width-42*SCREEN_RADIO)/3;
        }else if (model.pictureBigs.count==5 || model.pictureBigs.count==6){
            _height+=((screen_width-42*SCREEN_RADIO)/3)*2+6*SCREEN_RADIO;
        }
        return _height;
    }
    
    return 340*SCREEN_RADIO;
}

-(EZJFastTableView *)tbv{
    if (!_tbv) {
        
        __weak typeof(self) weakSelf = self;
        CGRect tbvFrame = CGRectMake(0, 64*SCREEN_RADIO, self.view.frame.size.width, screen_height-104*SCREEN_RADIO);
        //初始化
        
        _tbv = [[EZJFastTableView alloc]initWithFrame:tbvFrame];
        _tbv.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tbv.backgroundColor=[UIColor getColor:@"EEEEEE"];
        //给tableview赋值
        NSMutableArray *newArr=[CGIndexModel reloadTableWithRangeFrom:0 rangeTLenth:10];
        [newArr insertObject:@"headerView" atIndex:0];
        [_tbv setDataArray:newArr];
        
        [_tbv onBuildCell:^(id cellData,NSString *cellIdentifier,NSIndexPath *index) {
            UITableViewCell *inCell;
            if (index.row==0) {
                WSCollectionHeaderCell *cell = [[WSCollectionHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                
                return (UITableViewCell *)cell;
            }else{
                CGIndexModel *indexModel=(CGIndexModel *)cellData;
                if ([indexModel.type integerValue]==1) {
                    WSCollectionCell *cell = [[WSCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier WithModel:indexModel];
                    return (UITableViewCell *)cell;
                }else if ([indexModel.type integerValue]==2){
                    XLVideoCell *cell = [[XLVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withModel:indexModel withImg:indexModel.videoPic];
                    return (UITableViewCell *)cell;
                }
            }
            
            
            return (UITableViewCell *)inCell;
            
            
            
        }];
        
        //动态改变
        
        [_tbv onChangeCellHeight:^CGFloat(NSIndexPath *indexPath,id cellData) {
            
            if (indexPath.row==0) {
                return 104*SCREEN_RADIO;
            }
            
            CGFloat _height=[weakSelf getCellHeightWithModel:cellData];
            return _height;
        }];
        
        
        
        //允许上行滑动
        [_tbv onDragUp:^(int page) {
            [weakSelf getCollectionData:page];
        }];
        
        //允许下行滑动刷新
        //            [_tbv onDragDown:^{
        //                [weakSelf getCollectionData];
        //            }];
        
        
        //设置选中事件 block设置方式
        //indexPath  是当前行对象 indexPath.row(获取行数)
        //cellData 是当前行的数据
        
        [_tbv onCellSelected:^(NSIndexPath *indexPath, id cellData) {
            NSLog(@"click");
            if (indexPath.row!=0) {
                CGIndexModel *indexModel=(CGIndexModel *)cellData;
                if ([indexModel.type integerValue]==2) {
                    [self showVideoPlayer:indexPath withcellData:cellData];
                }
            }
        }];
        
        [_tbv onScrollDid:^(UIScrollView *scrollView) {
            if ([scrollView isEqual:self.tbv]) {
                [weakSelf.player playerScrollIsSupportSmallWindowPlay:NO];
            }
        }];
        
    }
    
    return _tbv;
}

- (void)showVideoPlayer:(NSIndexPath *)index withcellData:(CGIndexModel *)cellData{
    [_player destroyPlayer];
    _player = nil;
    
    _indexPath = index;
    XLVideoCell *cell = [self.tbv cellForRowAtIndexPath:_indexPath];
    // [cell hiddenPlayView:YES];
    
    
    //    //2.将indexPath添加到数组
    //    NSArray <NSIndexPath *> *indexPathArray = @[index];
    //    //3.传入数组，对当前cell进行刷新
    //    [self.tbv reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
    __weak typeof(self) weakSelf = self;
    _player = [[XLVideoPlayer alloc] initWithFrame:CGRectMake(0, 56*SCREEN_RADIO, screen_width, 284*SCREEN_RADIO) withVideoPauseBlock:^{
        CGVideoViewController *videoVC=[[CGVideoViewController alloc] init];
        videoVC.videoStr=cellData.bigIcon;
        [weakSelf.navigationController presentViewController:videoVC animated:NO completion:nil];
    } withPlayBlock:^{
        
    }];
    _player.videoUrl = cellData.bigIcon;
    [_player playerBindTableView:self.tbv currentIndexPath:_indexPath];
    
    [cell.contentView addSubview:_player];
    
    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
        [cell hiddenPlayView:NO];
        [player destroyPlayer];
        _player = nil;
    };
    
}




@end

