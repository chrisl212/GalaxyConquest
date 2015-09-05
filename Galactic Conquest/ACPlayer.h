//
//  ACPlayer.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ACPlayerKeyName;
extern NSString *const ACPlayerKeyColor;
extern NSString *const ACPlayerKeyImage;

@interface ACPlayer : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIImage *image;

- (id)initWithName:(NSString *)name;

@end
