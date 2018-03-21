//
//  ZQCHomeBannerView.m
//  Financial
//
//  Created by ss on 2018/3/20.
//  Copyright © 2018年 ZQC. All rights reserved.
//

#import "ZQCHomeBannerView.h"
#import "ZQCHomeBannerCell.h"
#import "ZQCHomePageControl.h"


@interface ZQCHomeBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *CollectionView;
    ZQCHomePageControl *PageControl;
}
@property (nonatomic,strong) NSMutableArray *arrayModels;
@property (nonatomic,copy) NSArray *currentArrayModels;
/** 定时器方法 */
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,assign) BOOL loop;// 是否是自动滚动
@property (nonatomic,assign) NSTimeInterval timeInterval;// 默认循环时间
@end


@implementation ZQCHomeBannerView

#pragma mark - Meth
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIWithFrame:frame];
    }
    return self;
}

#pragma mark - PraviteMeth
- (void)setupUIWithFrame:(CGRect)frame {
    
    self.arrayModels = @[].mutableCopy;
    self.timeInterval = 1.5f; // 默认循环时间
    self.loop = YES;          // 默认自动循环
    
    // 创建CollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    CollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    CollectionView.showsHorizontalScrollIndicator = NO;
    CollectionView.scrollEnabled = YES;
    CollectionView.pagingEnabled = YES;
    CollectionView.bounces       = YES;
    CollectionView.delegate      = self;
    CollectionView.dataSource    = self;
    [CollectionView registerClass:[ZQCHomeBannerCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:CollectionView];
    
    // 创建PageControl
    PageControl = [[ZQCHomePageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
    [self addSubview:PageControl];
}

#pragma mark - ClassMeth
- (void)setHomeBannerArrayModels:(NSArray *)arrayModels {
    self.currentArrayModels = arrayModels;
    PageControl.numberOfPages = arrayModels.count;
    
    [self.arrayModels removeAllObjects];
    [self.arrayModels addObjectsFromArray:arrayModels];
    
    if (self.arrayModels.count > 0 && self.loop) {
        [self.arrayModels insertObject:[arrayModels lastObject] atIndex:0];
        [self.arrayModels addObject:[arrayModels firstObject]];
        [CollectionView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    }
    
    [self stopTimer];
    [self startTimer];
    
    [CollectionView reloadData];
}
#pragma mark - UICollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayModels.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageName = self.arrayModels[indexPath.row];
    ZQCHomeBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setBannerImage:imageName];
    return cell;
}

//定义每个UICollectionView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width , self.frame.size.height);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


#pragma mark - UIScrollViewDelegare
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page = scrollView.contentOffset.x / scrollView.bounds.size.width ;
    if (page == 0) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(self.arrayModels.count - 2), 0) animated:NO];
        PageControl.currentPage = self.arrayModels.count - 2;
    } else if ((int)page == self.arrayModels.count - 1 ) {
        [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        PageControl.currentPage = 0;
    } else {
        PageControl.currentPage = (int)page - 1;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止计时器
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 打开计时器
    [self startTimer];
}


#pragma mark - 定时器方法
/**
 *  开启定时器
 */
- (void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  关闭定时器
 */
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    
    NSInteger page = CollectionView.contentOffset.x / CollectionView.bounds.size.width ;
    
    CGPoint offset = CollectionView.contentOffset;
    offset.x = (page + 1) * CollectionView.frame.size.width;
    [CollectionView setContentOffset:offset animated:YES];

}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    if (self.arrayModels.count > indexPath.row) {
        [CollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}
@end
