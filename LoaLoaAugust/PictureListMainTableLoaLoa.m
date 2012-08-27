//
//  PictureListMainTableLoaLoa.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/27/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "PictureListMainTableLoaLoa.h"

@interface PictureListMainTableLoaLoa ()

@end

@implementation PictureListMainTableLoaLoa

- (void)loaLoaButtonPressed:(id)sender {
    UIStoryboard *LoaLoaStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    UIViewController *initialLoaLoaViewController=[LoaLoaStoryboard instantiateInitialViewController];
    initialLoaLoaViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:initialLoaLoaViewController animated:YES];
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
    // Do any additional setup after loading the view.

    [super viewDidLoad];
    NSLog(@"in loaloa viewdidload");

    /*UIBarButtonItem *loaLoaButtonPointer=[[UIBarButtonItem alloc] initWithTitle:@"LoaLoa" style:(UIBarButtonItemStyleDone) target:self action:@selector(loaLoaButtonPressed:)];
    UIBarButtonItem *logoutButtonPointer=[[UIBarButtonItem alloc] initWithTitle:@"Log" style:(UIBarButtonItemStyleDone) target:self action:@selector(logoutButtonPressed:)];
    NSArray *buttonArray=[[NSArray alloc] initWithObjects:logoutButtonPointer,loaLoaButtonPointer, nil];
    self.navigationItem.leftBarButtonItems=buttonArray;
     */

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
