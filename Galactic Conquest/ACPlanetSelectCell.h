//
//  ACPlanetSelectCell.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface ACPlanetSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SCNView *sceneView;
@property (weak, nonatomic) IBOutlet UILabel *planetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;

@end
