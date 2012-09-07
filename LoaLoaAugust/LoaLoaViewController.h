//
//  LoaLoaViewController.h
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/22/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSUserContext.h"

@interface LoaLoaViewController : UIViewController
@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, assign) BOOL viewDisappeared;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CSUserContext *userContext;

//@property (nonatomic, strong) CSUserContext *userContext;
//@property (nonatomic, strong) NSMutableArray *pictureListData;


-(IBAction)mainAppButtonPressed:(id)sender;
@end
