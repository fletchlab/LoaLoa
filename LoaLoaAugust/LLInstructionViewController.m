//
//  LLInstructionViewController.m
//  LoaLoaAugust
//
//  Created by Matthew Bakalar on 9/9/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "LLInstructionViewController.h"
#import "CaptureViewControllerLoaLoa.h"
#import <QuartzCore/QuartzCore.h>

@interface LLInstructionViewController ()

@end

@implementation LLInstructionViewController

@synthesize userContext;
@synthesize managedObjectContext;
@synthesize scrollView;

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"CaptureImage"]) {
        // Get a reference to the capture view
        CaptureViewControllerLoaLoa *cvc = (CaptureViewControllerLoaLoa*)[segue destinationViewController];
        cvc.userContext = self.userContext;
        cvc.managedObjectContext = self.managedObjectContext;
    }
    else if([segue.identifier isEqualToString:@"NextInstruction"]) {
        // Get a reference to the LLInstruction view controller
        LLInstructionViewController *vc = (LLInstructionViewController*)[segue destinationViewController];
        vc.userContext = self.userContext;
        vc.managedObjectContext = self.managedObjectContext;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
