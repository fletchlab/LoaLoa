//
//  ReviewViewController.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 9/10/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "ReviewViewController.h"
#import "CaptureViewControllerLoaLoa.h"
#import "LLInstructionViewController.h"

@interface ReviewViewController ()
@end

@implementation ReviewViewController
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
     //NSLog(@"%i",numContours);


	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setAccept:nil];
    [self setReject:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AcceptFirstRun"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        LLInstructionViewController *ivc = (LLInstructionViewController *)[[navController viewControllers] lastObject];
        
        // Pass Core Data and CellScope user context to next view
        ivc.managedObjectContext = self.managedObjectContext;
        ivc.userContext = self.userContext;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)acceptData:(id)sender {
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    
    UINavigationController *navController = self.navigationController;
    [[navController viewControllers] objectAtIndex:0];
    LLInstructionViewController *ivc = (LLInstructionViewController *)[[navController viewControllers] objectAtIndex:0];    
    ivc.managedObjectContext = self.managedObjectContext;
    ivc.userContext = self.userContext;
    [self presentModalViewController:ivc animated:YES];
}

@end
