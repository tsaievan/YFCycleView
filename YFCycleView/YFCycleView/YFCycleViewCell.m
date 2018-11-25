//
//  YFCycleViewCell.m
//  YFCycleView
//
//  Created by tsaievan on 25/11/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import "YFCycleViewCell.h"

@interface YFCycleViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation YFCycleViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}


- (void)setUrl:(NSURL *)url {
    _url = url;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    });
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

@end
