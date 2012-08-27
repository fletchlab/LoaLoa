//
//  LoaLoaViewController.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/22/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "LoaLoaViewController.h"

@interface LoaLoaViewController ()

@end

@implementation LoaLoaViewController
- (IBAction)mainAppButtonPressed:(id)sender {
    if (self.viewAppeared==YES){
        //[self dismissModalViewControllerAnimated:YES];
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *initialMainViewController=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"loginViewControllerID"];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
