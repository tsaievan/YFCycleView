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

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray <NSURL *> *)urls placeholderImage:(UIImage *)placeholderImage {
    if (self = [self initWithFrame:frame urls:urls]) {
        _placeholderImage = placeholderImage;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray <NSURL *> *)urls {
    if (self = [self initWithFrame:frame]) {
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
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[YFCycleViewCell class] forCellWithReuseIdentifier:YFCycleViewCellReuseIdentifier];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.superview != nil) {
                [self.superview addSubview:self.pageControl];
                CGFloat pageControlW = self.pageControl.bounds.size.width;
                CGFloat pageControlH = self.pageControl.bounds.size.height;
                CGFloat pageControlX = (self.frame.size.width - pageControlW) * 0.5;
                CGFloat pageControlY = (self.frame.origin.y  + self.frame.size.height) - pageControlH;
                self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
                self.pageControl.numberOfPages = self -> _urls.count;
                self.pageControl.pageIndicatorTintColor = (self.pageIndicatorTintColor == nil) ? [UIColor orangeColor] : self.pageIndicatorTintColor;
                self.pageControl.currentPageIndicatorTintColor = (self.currentPageIndicatorTintColor == nil) ? [UIColor blueColor] : self.currentPageIndicatorTintColor;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self -> _urls.count) * 500 inSection:0];
            if (self -> _urls == nil || self -> _urls.count == 0) {
                indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }
            [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            if (self.autoCycle) {
                NSTimer *timer = [NSTimer timerWithTimeInterval:self.cycleTimeGap == 0 ? 5 : self.cycleTimeGap target:self selector:@selector(autoCycleAction) userInfo:nil repeats:YES];
                self.autoCycleTimer = timer;
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
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
    if (self.superview != nil) {
        [self.superview addSubview:self.pageControl];
        CGFloat pageControlW = self.pageControl.bounds.size.width;
        CGFloat pageControlH = self.pageControl.bounds.size.height;
        CGFloat pageControlX = (self.frame.size.width - pageControlW) * 0.5;
        CGFloat pageControlY = (self.frame.origin.y  + self.frame.size.height) - pageControlH;
        self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
        self.pageControl.numberOfPages = self -> _urls.count;
        self.pageControl.pageIndicatorTintColor = (self.pageIndicatorTintColor == nil) ? [UIColor orangeColor] : self.pageIndicatorTintColor;
        self.pageControl.currentPageIndicatorTintColor = (self.currentPageIndicatorTintColor == nil) ? [UIColor blueColor] : self.currentPageIndicatorTintColor;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self -> _urls.count * 500 inSection:0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    });
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
        });
    }else {
        [self reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_urls == nil || _urls.count == 0) {
        return 1;
    }
    return _urls.count * 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YFCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YFCycleViewCellReuseIdentifier forIndexPath:indexPath];
    if (_urls == nil || _urls.count == 0) {
        cell.placeholderImage = self.placeholderImage;
    }else {
        cell.url = _urls[indexPath.item % _urls.count];
    }
//    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger offset = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger pageNumber = offset % _urls.count;
    self.pageControl.currentPage = pageNumber;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
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
    if (self.autoCycle) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:self.cycleTimeGap == 0 ? 5 : self.cycleTimeGap target:self selector:@selector(autoCycleAction) userInfo:nil repeats:YES];
        self.autoCycleTimer = timer;
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

- (void)autoCycleAction {
    [self setContentOffset:CGPointMake(self.contentOffset.x + self.bounds.size.width, 0) animated:YES];
}


- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        _pageControl.pageIndicatorTintColor = (self.pageIndicatorTintColor == nil) ? [UIColor orangeColor] : self.pageIndicatorTintColor;
        _pageControl.currentPageIndicatorTintColor = (self.pageIndicatorTintColor == nil) ? [UIColor orangeColor] : self.pageIndicatorTintColor;
        _pageControl.numberOfPages = 10;
    }
    return _pageControl;
}

@end
