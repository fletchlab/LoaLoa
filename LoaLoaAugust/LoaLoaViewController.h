//
//  LoaLoaViewController.h
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/22/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaLoaViewController : UIViewController
@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, assign) BOOL viewDisappeared;

-(IBAction)mainAppButtonPressed:(id)sender;
@end
