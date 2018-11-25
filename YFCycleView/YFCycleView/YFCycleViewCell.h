//
//  YFCycleViewCell.h
//  YFCycleView
//
//  Created by tsaievan on 25/11/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFCycleViewCell : UICollectionViewCell

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIImage *placeholderImage;

@end

NS_ASSUME_NONNULL_END
