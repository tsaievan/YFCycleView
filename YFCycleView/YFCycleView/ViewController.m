//
//  ViewController.m
//  YFCycleView
//
//  Created by tsaievan on 25/11/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import "ViewController.h"
#import "YFCycleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YFCycleView *cycleView = [[YFCycleView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) urls:nil placeholderImage:[UIImage imageNamed:@"02.jpg"]];
    NSMutableArray *mtArr = @[].mutableCopy;
    for (int i = 0; i < 5; i++) {
        NSString *fileString = [NSString stringWithFormat:@"%02d.jpg", i + 1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileString withExtension:nil];
        [mtArr addObject:url];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleView.urls = mtArr.copy;
    });
    cycleView.cycleTimeGap = 2;
    cycleView.autoCycle = YES;
//    UIImage *image = [UIImage imageNamed:@"02.jpg"];
//    cycleView.placeholderImage = image;
    [self.view addSubview:cycleView];
}


@end
