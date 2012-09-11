//
//  ReviewViewController.h
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 9/10/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSUserContext.h"

int numContours;
@interface ReviewViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CSUserContext *userContext;
@property (nonatomic, strong) UIImage *differenceImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *accept;
@property (weak, nonatomic) IBOutlet UIButton *reject;

- (IBAction)acceptData:(id)sender;




@end
