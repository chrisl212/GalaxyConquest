//
//  ACBuildTableViewDataSource.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACBuildTableViewDataSource.h"
#import "ACShip.h"
#import "ACBuildCell.h"

@implementation ACBuildTableViewDataSource
{
    NSArray *tableViewItems;
    NSArray *sectionTitles;
}

- (id)initWithDelegate:(id<ACBuildDelegate>)delegate
{
    if (self = [super init])
    {
        NSMutableArray *shipsArray = [NSMutableArray array];
        NSArray *shipsFilePathsArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"ship" inDirectory:nil];
        for (NSString *filePath in shipsFilePathsArray)
        {
            [shipsArray addObject:[[ACShip alloc] initWithFile:filePath]];
        }
        
        NSArray *buildButtonArray = @[@"Build"];
        
        sectionTitles = @[@"Ships", @""];
        tableViewItems = @[shipsArray, buildButtonArray];
        
        self.delegate = delegate;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableViewItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewItems[section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *cellID = @"Cell";
        ACBuildCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        ACShip *ship = tableViewItems[indexPath.section][indexPath.row];
        cell.shipNameLabel.text = ship.name;
        cell.shipMineralsCostLabel.text = [NSString stringWithFormat:@"Minerals: %ld", ship.mineralsCost];
        cell.shipFuelCostLabel.text = [NSString stringWithFormat:@"Fuel: %ld", ship.fuelCost];
        
        cell.shipSceneView.scene = [SCNScene sceneWithURL:[NSURL fileURLWithPath:ship.scenePath] options:nil error:nil];
        cell.shipSceneView.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else
    {
        NSString *cellID = @"Build";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.text = @"Build";
        cell.textLabel.textColor = [UIColor whiteColor];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 80.0;
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == tableViewItems.count - 1)
    {
        if ([self.delegate respondsToSelector:@selector(userDidBuildShips:cost:)])
        {
            NSMutableArray *ships = [NSMutableArray array];
            
            ACBuildCost cost;
            cost.fuelCost = 0;
            cost.mineralsCost = 0;
            for (int i = 0; i < [tableViewItems[0] count]; i++)
            {
                ACBuildCell *cell = (ACBuildCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                NSInteger numberOfShips = cell.shipQuantityLabel.text.integerValue;
                ACShip *ship = tableViewItems[0][i];
                for (int i = 0; i < numberOfShips; i++)
                {
                    cost.fuelCost += ship.fuelCost;
                    cost.mineralsCost += ship.mineralsCost;
                    [ships addObject:[ship copy]];
                }
            }
            
            if (![self.delegate userCanAffordCost:cost])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You do not have enough resources to afford this purchase" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }

            [self.delegate userDidBuildShips:[NSArray arrayWithArray:ships] cost:cost];
        }
    }
}

@end
