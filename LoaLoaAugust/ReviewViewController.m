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
#import "ResultsViewController.h"

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

- (IBAction)reject:(id)sender {
    
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    CaptureViewControllerLoaLoa* capture=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"Capture1"];
    //NSArray *viewControllerArray = [initialMainViewController viewControllers];
    //PictureListMainTableLoaLoa *initialVC=[viewControllerArray objectAtIndex:0];
    capture.managedObjectContext=self.managedObjectContext;
    capture.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    capture.repetition=self.repetition;

    [self presentModalViewController:capture animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [imageView setImage:_differenceImage];
     NSLog(@"numcontours %i",_numContoursReview);
    NSString *description= [NSString stringWithFormat:@"Microfilariae: %i", _numContoursReview];

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AcceptFirstRun"]) {
        if (_repetition<4){

        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        LLInstructionViewController *ivc = (LLInstructionViewController *)[[navController viewControllers] lastObject];
        
        // Pass Core Data and CellScope user context to next view
        ivc.managedObjectContext = self.managedObjectContext;
        ivc.userContext = self.userContext;
        ivc.repetition=self.repetition;
        }
        else {
            UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
            ResultsViewController *rvc=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"Results1"];
            rvc.managedObjectContext = self.managedObjectContext;
            rvc.userContext = self.userContext;
            rvc.repetition=self.repetition+1;
            [self presentModalViewController:rvc animated:YES];

        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        return YES;
    }
    else {
        return NO;
    }

}

- (IBAction)acceptData:(id)sender {
    NSLog(@"from review, repetition is %i",_repetition);
    if (_repetition<2){
    //UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    
    UINavigationController *navController = self.navigationController;
    [[navController viewControllers] objectAtIndex:0];
    LLInstructionViewController *ivc = (LLInstructionViewController *)[[navController viewControllers] objectAtIndex:0];    
    ivc.managedObjectContext = self.managedObjectContext;
    ivc.userContext = self.userContext;
    ivc.repetition=self.repetition;
    [self presentModalViewController:ivc animated:YES];
    }
    else {
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
        CaptureViewControllerLoaLoa *cvc=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"Results1"];
        cvc.managedObjectContext = self.managedObjectContext;
        cvc.userContext = self.userContext;
        cvc.repetition=self.repetition+1;
        [self presentModalViewController:cvc animated:YES];
        //[self performSegueWithIdentifier:@"ShowResults" sender:self];

    }
}

@end
