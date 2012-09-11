//
//  ReviewViewController.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 9/10/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "ReviewViewController.h"
#import "CaptureViewControllerLoaLoa.h"

@interface ReviewViewController ()
@end

@implementation ReviewViewController
@synthesize numContoursTitle;
@synthesize imageView;
@synthesize accept;
@synthesize reject;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)accept:(id)sender {
    
    

}
- (IBAction)reject:(id)sender {
    
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    CaptureViewControllerLoaLoa* capture=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"Capture1"];
    //NSArray *viewControllerArray = [initialMainViewController viewControllers];
    //PictureListMainTableLoaLoa *initialVC=[viewControllerArray objectAtIndex:0];
    capture.managedObjectContext=self.managedObjectContext;
    capture.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:capture animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [imageView setImage:_differenceImage];
     NSLog(@"numcontours %i",_numContoursReview);
    NSString *description= [NSString stringWithFormat:@"Microfillae: %i", _numContoursReview];

    numContoursTitle.text=description;
    numContoursTitle.textColor = [UIColor redColor];



	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setAccept:nil];
    [self setReject:nil];
    [self setNumContoursTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
