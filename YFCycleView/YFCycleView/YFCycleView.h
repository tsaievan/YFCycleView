//
//  YFCycleView.h
//  YFCycleView
//
//  Created by tsaievan on 25/11/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFCycleView : UICollectionView

@property (nonatomic, strong) NSArray <NSURL *> *urls;

@property (nonatomic, assign) BOOL autoCycle;

@property (nonatomic, assign) NSTimeInterval cycleTimeGap;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;


- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame urls:(nullable NSArray <NSURL *> *)urls;

- (instancetype)initWithFrame:(CGRect)frame urls:(nullable NSArray <NSURL *> *)urls placeholderImage:(UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
