//
//  ACBuildCell.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface ACBuildCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *shipImageView;
@property (weak, nonatomic) IBOutlet UILabel *shipNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipFuelCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *shipMineralsCostLabel;
@property (weak, nonatomic) IBOutlet UIStepper *shipQuantityStepper;
@property (weak, nonatomic) IBOutlet UILabel *shipQuantityLabel;

@end
