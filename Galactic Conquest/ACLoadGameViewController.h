//
//  ACLoadGameViewController.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACGame;
@protocol ACLoadGameViewControllerDelegate;

@interface ACLoadGameViewController : UITableViewController

@property (weak, nonatomic) id<ACLoadGameViewControllerDelegate> delegate;

- (id)initWithDelegate:(id<ACLoadGameViewControllerDelegate>)del;

@end

@protocol ACLoadGameViewControllerDelegate <NSObject>

@optional
- (void)gameWasSelected:(ACGame *)game;

@end
