//
//  ACFleetsTableViewDataSource.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACFleetsTableViewDataSource.h"
#import "ACFleet.h"
#import "ACPlanet.h"
#import "ACPlayer.h"
#import "ACPlanetSelectDataSource.h"

@implementation ACFleetsTableViewDataSource
{
    ACPlanetSelectDataSource *planetSelectDataSource;
    NSArray *fleets;
}

- (id)initWithPlanet:(ACPlanet *)planet delegate:(id<ACFleetsTableDelegate>)delegate
{
    if (self = [super init])
    {
        self.delegate = delegate;
        fleets = planet.fleets;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fleets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    
    ACFleet *fleet = fleets[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", fleet.name, fleet.owner.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld ships", fleet.ships.count];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.font = font;
    cell.detailTextLabel.font = font;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 300.0, 30.0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    return button;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACFleet *fleet = fleets[indexPath.row];
    
    planetSelectDataSource = [[ACPlanetSelectDataSource alloc] initWithFleet:fleet delegate:nil];
    UITableView *planetSelectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 300.0) style:UITableViewStyleGrouped];
    [planetSelectTableView registerNib:[UINib nibWithNibName:@"ACPlanetSelectCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    planetSelectTableView.dataSource = planetSelectDataSource;
    planetSelectTableView.delegate = planetSelectDataSource;
    planetSelectTableView.center = tableView.center;
    planetSelectTableView.backgroundColor = [UIColor blackColor];
    planetSelectTableView.alpha = 0.0;
    [tableView.superview addSubview:planetSelectTableView];

    [UIView animateWithDuration:0.5 animations:^{
        planetSelectTableView.alpha = 1.0;
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)planetWasSelected:(ACPlanet *)planet
{
    
}

- (void)dismiss
{
    [self.delegate dismissFleetsTable];
}

@end
