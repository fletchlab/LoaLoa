//
//  ResultsViewController.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 9/10/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "ResultsViewController.h"
#import "LLMainMenuViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*- (IBAction)retest:(id)sender {
    UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    //UINavigationController *mmvc=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"MainMenu"];
    //NSArray *viewControllerArray = [mmvc viewControllers];
    LLMainMenuViewController *mvc=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"MainMenu"];
    mvc.managedObjectContext=self.managedObjectContext;
    mvc.userContext=self.userContext;

    mvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:mvc animated:YES];

}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        // Get a reference to the capture view
        UINavigationController * mmnc = (UINavigationController*)[segue destinationViewController];
        NSArray *viewControllerArray = [mmnc viewControllers];
        LLMainMenuViewController *mvc=[viewControllerArray objectAtIndex:0];
        mvc.userContext = self.userContext;
        mvc.managedObjectContext = self.managedObjectContext;
        NSLog(@"back to main menu");
        
        
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
