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
    YFCycleView *cycleView = [[YFCycleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    NSMutableArray *mtArr = @[].mutableCopy;
    for (int i = 0; i < 5; i++) {
        NSString *fileString = [NSString stringWithFormat:@"%02d.jpg", i + 1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:fileString withExtension:nil];
        [mtArr addObject:url];
    }
    cycleView.urls = mtArr.copy;
    cycleView.cycleTimeGap = 2;
    cycleView.autoCycle = YES;
    [self.view addSubview:cycleView];
}


@end
