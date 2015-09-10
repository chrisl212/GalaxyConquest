//
//  ACBuildCell.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACBuildCell.h"

@implementation ACBuildCell

- (void)awakeFromNib
{
    [self.shipQuantityStepper addObserver:self forKeyPath:@"value" options:kNilOptions context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.shipQuantityLabel.text = [NSString stringWithFormat:@"%.0lF", self.shipQuantityStepper.value];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)removeFromSuperview
{
    [self.shipQuantityStepper removeObserver:self forKeyPath:@"value"];
}

@end
