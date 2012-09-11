//
//  LLInstructionViewController.h
//  LoaLoaAugust
//
//  Created by Matthew Bakalar on 9/9/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSUserContext.h"

@interface LLInstructionViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CSUserContext *userContext;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property int soundNum;
@property int repetition;

- (IBAction)loopToCapture:(id)sender;

@end
