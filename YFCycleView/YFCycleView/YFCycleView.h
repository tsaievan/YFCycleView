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

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
