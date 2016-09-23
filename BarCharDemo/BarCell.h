//
//  BarCell.h
//  BarCharDemo
//
//  Created by zhanglu on 9/22/16.
//  Copyright © 2016 zhanglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *barLabel;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat labelHeight;

@end
