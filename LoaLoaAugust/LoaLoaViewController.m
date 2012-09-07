//
//  LoaLoaViewController.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/22/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "LoaLoaViewController.h"
#import "AppDelegate.h"
#import "PictureListMainTableLoaLoa.h"
#import "CaptureViewControllerLoaLoa.h"

@interface LoaLoaViewController ()

@end

@implementation LoaLoaViewController
@synthesize managedObjectContext;
- (IBAction)mainAppButtonPressed:(id)sender {
    if (self.viewAppeared==YES){
        //[self dismissModalViewControllerAnimated:YES];
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main_IPhone_Storyboard" bundle:nil];
        UINavigationController *initialMainViewController=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"LoaLoaHome"];
        NSArray *viewControllerArray = [initialMainViewController viewControllers];
        PictureListMainTableLoaLoa *initialVC=[viewControllerArray objectAtIndex:0];
        initialVC.managedObjectContext=self.managedObjectContext;
        initialMainViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:initialMainViewController animated:YES];
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    self.viewAppeared = YES;

}

-(void)viewDidDisappear:(BOOL)animated {
    self.viewDisappeared = YES;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CapturePictureLoaLoa"]) {
        // Get a reference to the capture view
        CaptureViewControllerLoaLoa *cvc = (CaptureViewControllerLoaLoa*)[segue destinationViewController];
        cvc.userContext = self.userContext;
        cvc.managedObjectContext = self.managedObjectContext;
    }
    
    if([segue.identifier isEqualToString:@"LoaLoaInst1"]) {
        // Get a reference to the capture view
        UINavigationController * llnc = (UINavigationController*)[segue destinationViewController];
        NSArray *viewControllerArray = [llnc viewControllers];
        LoaLoaViewController *lvc=[viewControllerArray objectAtIndex:0];
        lvc.userContext = lvc.userContext;
        lvc.managedObjectContext = self.managedObjectContext;
        NSLog(@"transfered db to next loaloavc");
    }

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
