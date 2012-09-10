//
//  LLMainMenuViewController.h
//  LoaLoaAugust
//
//  Created by Matthew Bakalar on 9/9/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSUserContext.h"

@interface LLMainMenuViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CSUserContext *userContext;

@end
