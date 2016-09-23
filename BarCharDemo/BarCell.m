//
//  BarCell.m
//  BarCharDemo
//
//  Created by zhanglu on 9/22/16.
//  Copyright © 2016 zhanglu. All rights reserved.
//

#import "BarCell.h"

@interface BarCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barLabelHeightConstraint;

@end

@implementation BarCell

- (void)awakeFromNib {
    self.barLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.barLabel.layer.borderWidth = 0.5;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setLabelHeight:(CGFloat)labelHeight {
    _labelHeight = labelHeight;
    self.barLabelHeightConstraint.constant = labelHeight;
}

@end
