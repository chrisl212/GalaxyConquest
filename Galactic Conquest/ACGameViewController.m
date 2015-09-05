//
//  ACGameViewController.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGameViewController.h"
#import "ACMainMenuScene.h"

@implementation ACGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SKView *skView = [[SKView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:skView];
    
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:skView.frame.size];
    [skView presentScene:mainMenuScene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
