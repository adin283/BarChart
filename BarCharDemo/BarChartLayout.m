//
//  BarChartLayout.m
//  BarCharDemo
//
//  Created by Kevin on 2016/9/23.
//  Copyright © 2016年 zhanglu. All rights reserved.
//

#import "BarChartLayout.h"
#import "BarCell.h"

@interface BarChartLayout()

@property (assign, nonatomic) NSInteger cellCount;
@property (assign, nonatomic) CGFloat offset;
@property (assign, nonatomic) CGSize cellSize;
@property (assign, nonatomic) CGFloat centerPointOffsetX;

@end

@implementation BarChartLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.offset = 0;
        self.snap = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.offset = 0;
        self.snap = NO;
        self.cellSize = CGSizeMake(30, 200);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.cellCount = self.collectionView.numberOfSections > 0 ? [self.collectionView numberOfItemsInSection:0] : 0;
    self.offset = self.collectionView.contentOffset.x / self.cellSize.width;
    self.centerPointOffsetX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.cellSize.width * self.cellCount + (self.collectionView.bounds.size.width / 2.0 - self.cellSize.width / 2) * 2, self.cellSize.height);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [NSMutableArray array];
    CGFloat maxVisible = self.collectionView.bounds.size.width / self.cellSize.width;
    
    for (NSInteger i = 0; i < self.cellCount; i++) {
        CGRect itemFrame = [self getRectForItemAtIndex:i];
        
        if (CGRectIntersectsRect(rect, itemFrame) && i >= floorf(self.offset - maxVisible / 2.0) && i < ceilf(self.offset + maxVisible / 2.0)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [theLayoutAttributes addObject:theAttributes];
        }
    }
    return theLayoutAttributes;
}

- (CGRect)getRectForItemAtIndex:(NSInteger)index
{
    return CGRectMake(index * self.cellSize.width + self.collectionView.bounds.size.width / 2.0 - self.cellSize.width / 2.0, 0, self.cellSize.width, self.cellSize.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *theAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    theAttribute.size = self.cellSize;
    CGRect itemFrame =  [self getRectForItemAtIndex:indexPath.row];
    theAttribute.frame = itemFrame;
    BarCell *barCell = (BarCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (itemFrame.origin.x <= self.centerPointOffsetX && self.centerPointOffsetX <= itemFrame.origin.x + self.cellSize.width) {
        NSLog(@"current:%ld", indexPath.row);
        barCell.barLabel.backgroundColor = [UIColor redColor];
        if ([self.delegate respondsToSelector:@selector(currentCenterIndex:)]) {
            [self.delegate currentCenterIndex:indexPath.row];
        }
    } else {
        barCell.barLabel.backgroundColor = [UIColor blueColor];
    }
    
    return theAttribute;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.snap) {
        CGFloat cellWidth = self.cellSize.width;
        NSInteger index = (NSInteger)floorf(proposedContentOffset.x / cellWidth);
        NSInteger off = (NSInteger)proposedContentOffset.x % (NSInteger)cellWidth;
        
        CGFloat targetX = off > cellWidth * 0.5 && index <= self.cellCount ? (index + 1) * cellWidth : index * cellWidth;
        return CGPointMake(targetX, proposedContentOffset.y);
    }
    return proposedContentOffset;
}



@end
