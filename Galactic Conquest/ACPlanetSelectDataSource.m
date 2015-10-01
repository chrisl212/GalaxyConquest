//
//  ACPlanetSelectDataSource.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlanetSelectDataSource.h"
#import "ACGame.h"
#import "ACStar.h"
#import "ACPlanet.h"
#import "ACGalaxy.h"
#import "AppDelegate.h"
#import "ACPlanetSelectCell.h"
#import "ACFleet.h"

@implementation ACPlanetSelectDataSource
{
    NSArray *tableViewItems;
    UITableView *table;
}

- (ACGame *)currentGame
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).currentGame;
}

- (ACGalaxy *)currentGalaxy
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).currentGame.galaxy;
}

- (id)initWithFleet:(ACFleet *)fleet delegate:(id<ACPlanetSelectDelegate>)delegate
{
    if (self = [super init])
    {
        self.fleet = fleet;
        self.delegate = delegate;
        NSMutableArray *planets = @[].mutableCopy;
        for (ACStar *star in [self currentGalaxy].stars)
        {
            [planets addObject:@{@"star" : star.name, @"planets" : star.planets}];
        }
        tableViewItems = [NSArray arrayWithArray:planets];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    table = tableView;
    return tableViewItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!tableView.tableFooterView)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 300.0, 30.0);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"Cancel" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
        tableView.tableFooterView = button;
    }
    return [tableViewItems[section][@"planets"] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return tableViewItems[section][@"star"];
}

- (SCNScene *)sceneForPlanet:(ACPlanet *)planet inView:(SCNView *)view
{
    SCNScene *scene = [SCNScene scene];
    SCNNode *planetNode = [[SCNNode alloc] init];
    planetNode.geometry = [SCNSphere sphereWithRadius:2.0];
    planetNode.geometry.firstMaterial.diffuse.contents = planet.textureImage;
    [scene.rootNode addChildNode:planetNode];
    
    if (planet.atmosphere)
    {
        SCNNode *atmosphereNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:2.1]];
        atmosphereNode.opacity = 0.3;
        atmosphereNode.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
        [scene.rootNode addChildNode:atmosphereNode];
    }
    
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 0;
    camera.yFov = 0;
    camera.zNear = 0.0;
    camera.zFar = 10.0;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5);
    [scene.rootNode addChildNode:cameraNode];
    
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeSpot;
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = light;
    lightNode.position = SCNVector3Make(1.0, 1.0, 8.0);
    [scene.rootNode addChildNode:lightNode];
    
    view.pointOfView = cameraNode;
    return scene;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    ACPlanetSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    ACPlanet *planet = tableViewItems[indexPath.section][@"planets"][indexPath.row];
    cell.planetNameLabel.text = planet.name;
    cell.sceneView.scene = [self sceneForPlanet:planet inView:cell.sceneView];
    cell.sceneView.backgroundColor = [UIColor clearColor];
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %.0lF ly", [[self currentGalaxy] distanceFromStar:self.fleet.location.parentStar toStar:planet.parentStar]];
    
    cell.ownerLabel.text = [NSString stringWithFormat:@"Owner: %@", planet.owner.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACPlanet *planet = tableViewItems[indexPath.section][@"planets"][indexPath.row];
    [self dismiss];
    if ([planet isEqual:self.fleet.location])
        return;
    if ([self.fleet canMoveToPlanet:planet])
        [self.fleet moveToPlanet:planet];
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Not enough fuel to send fleet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        table.alpha = 0.0;
    }completion:^(BOOL finished)
     {
        if (finished)
            [table removeFromSuperview];
     }];
}

@end
