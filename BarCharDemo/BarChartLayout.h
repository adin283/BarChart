//
//  BarChartLayout.h
//  BarCharDemo
//
//  Created by Kevin on 2016/9/23.
//  Copyright © 2016年 zhanglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarChartLayoutDelegate <NSObject>

- (void)currentCenterIndex:(NSInteger)index;

@end

@interface BarChartLayout : UICollectionViewLayout

@property (assign, nonatomic) BOOL snap;
@property (weak, nonatomic) id<BarChartLayoutDelegate> delegate;

@end
