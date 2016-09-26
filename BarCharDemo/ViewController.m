//
//  ViewController.m
//  BarCharDemo
//
//  Created by zhanglu on 9/22/16.
//  Copyright © 2016 zhanglu. All rights reserved.
//

#import "ViewController.h"
#import "BarCell.h"
#import "BarChartLayout.h"

#define ScreenSize self.view.bounds.size
#define BarCollectionViewSize self.barCollectionView.bounds.size

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, BarChartLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *barCollectionView;
@property (strong, nonatomic) NSArray *xTitles;
@property (strong, nonatomic) NSArray *values;
@property (assign, nonatomic) NSUInteger currentCenterIndex;
@property (assign, nonatomic) CGFloat currentCenterOffsetX;
@property (assign, nonatomic) CGSize barSize;
@property (strong, nonatomic) BarChartLayout *layout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _xTitles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18"];
    _values = @[@10, @20, @50, @60, @30, @10, @70, @90, @100, @20, @60, @40, @77, @88, @12, @34, @40, @11];
//    self.barCollectionView.contentInset = UIEdgeInsetsMake(0, self.view.bounds.size.width / 2, 0, 0);
    self.barSize = CGSizeMake(30, 200);
    self.layout = (BarChartLayout *)self.barCollectionView.collectionViewLayout;
    self.layout.snap = YES;
    self.layout.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.barCollectionView.contentInset = UIEdgeInsetsMake(0, ScreenSize.width / 2 - 15, 0, ScreenSize.width / 2 - 15);
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:(_xTitles.count - 1) inSection:0];
    [self.barCollectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _xTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BarCell *barCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BarCell" forIndexPath:indexPath];
    NSString *title = self.xTitles[indexPath.row];
    NSNumber *value = self.values[indexPath.row];
    CGFloat mutil = (value.floatValue / 100.0);
    CGFloat colorLabelHeight = mutil * (164);
    barCell.labelHeight = colorLabelHeight;
    barCell.title = title;
    return barCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"click value---%@", self.values[indexPath.row]);
    [self.barCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.barCollectionView.frame);
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGPoint offset = CGPointMake(cell.center.x - collectionViewWidth / 2, 0);
    [collectionView setContentOffset:offset animated:YES];
}

#pragma mark - BarChartLayoutDelegate

- (void)currentCenterIndex:(NSInteger)index
{
    self.currentCenterIndex = index;
    // 这里 reload 造成死循环了 - -!!!,所以我把样式也写到layout里面了
    //    [self.barCollectionView reloadData];
}

@end
