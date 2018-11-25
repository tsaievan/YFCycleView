//
//  YFCycleView.m
//  YFCycleView
//
//  Created by tsaievan on 25/11/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import "YFCycleView.h"
#import "YFCycleViewFlowLayout.h"
#import "YFCycleViewCell.h"

static NSString *const YFCycleViewCellReuseIdentifier = @"YFCycleViewCellReuseIdentifier";

@interface YFCycleView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) NSTimer *autoCycleTimer;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YFCycleView {
    NSArray <NSURL *> * _urls;
}

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray <NSURL *> *)urls {
    if (self = [super initWithFrame:frame]) {
        _urls = urls;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame collectionViewLayout:[YFCycleViewFlowLayout new]]) {
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[YFCycleViewCell class] forCellWithReuseIdentifier:YFCycleViewCellReuseIdentifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self -> _urls.count) * 500 inSection:0];
            [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            NSTimer *timer = [NSTimer timerWithTimeInterval:self.cycleTimeGap == 0 ? 5 : self.cycleTimeGap target:self selector:@selector(autoCycleAction) userInfo:nil repeats:YES];
            self.autoCycleTimer = timer;
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        });
    }
    return self;
}

- (void)setUrls:(NSArray<NSURL *> *)urls {
    if (urls == nil || urls.count == 0) {
        return;
    }
    if (_urls == nil || _urls.count == 0) {
        _urls = urls;
    }
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }else {
        [self reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _urls.count * 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YFCycleViewCellReuseIdentifier forIndexPath:indexPath];
    cell.url = _urls[indexPath.item % _urls.count];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.autoCycleTimer invalidate];
    self.autoCycleTimer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger offset = scrollView.contentOffset.x / self.frame.size.width;
    if (offset >= [self numberOfItemsInSection:0] - 1) {
        offset = _urls.count - 1;
    }
    if (offset <= 0) {
        offset = _urls.count;
    }
    [scrollView setContentOffset:CGPointMake(offset * self.frame.size.width, 0)];
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.cycleTimeGap == 0 ? 5 : self.cycleTimeGap target:self selector:@selector(autoCycleAction) userInfo:nil repeats:YES];
    self.autoCycleTimer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)autoCycleAction {
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.bounds.size.width, 0) animated:YES];
}


@end
