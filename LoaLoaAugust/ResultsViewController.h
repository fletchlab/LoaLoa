//
//  ResultsViewController.h
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 9/10/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//
#import "CSUserContext.h"
#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CSUserContext *userContext;

@property int repetition;

@end
