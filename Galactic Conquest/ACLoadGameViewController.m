//
//  ACLoadGameViewController.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACLoadGameViewController.h"
#import "ACGame.h"

@implementation ACLoadGameViewController
{
    NSArray *tableViewItems;
}

- (NSArray *)localSaves
{
    NSString *localSavesPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Saves"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localSavesPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:localSavesPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localSavesPath error:nil];
    
    NSMutableArray *localSavesArray = @[].mutableCopy;
    for (NSString *name in fileNames)
    {
        [localSavesArray addObject:[localSavesPath stringByAppendingPathComponent:name]];
    }
    
    return localSavesArray;
}

- (id)initWithDelegate:(id<ACLoadGameViewControllerDelegate>)del
{
    if (self = [super initWithStyle:UITableViewStyleGrouped])
    {
        self.delegate = del;
        tableViewItems = @[
                           @{@"name" : @"Local", @"type" : @"filesystem", @"items" : [self localSaves]}
                           ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return tableViewItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewItems[section][@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    if ([tableViewItems[indexPath.section][@"type"] isEqualToString:@"filesystem"])
        cell.textLabel.text = [tableViewItems[indexPath.section][@"items"][indexPath.row] lastPathComponent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableViewItems[indexPath.section][@"type"] isEqualToString:@"filesystem"])
    {
        ACGame *game = [NSKeyedUnarchiver unarchiveObjectWithFile:tableViewItems[indexPath.section][@"items"][indexPath.row]];
        if ([self.delegate respondsToSelector:@selector(gameWasSelected:)])
            [self.delegate gameWasSelected:game];
    }
}

@end
