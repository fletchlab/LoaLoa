//
//  PictureListMainTableLoaLoa.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/27/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "PictureListMainTableLoaLoa.h"
#import "LoaLoaViewController.h"
#import "AppDelegate.h"

@interface PictureListMainTableLoaLoa ()

@end

@implementation PictureListMainTableLoaLoa
- (void)loaLoaButtonPressed:(id)sender {
    UIStoryboard *LoaLoaStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
    UINavigationController *initialLoaLoaViewController=[LoaLoaStoryboard instantiateInitialViewController];
    NSArray *viewControllerArray = [initialLoaLoaViewController viewControllers];
    LoaLoaViewController *initialVC=[viewControllerArray objectAtIndex:0];
    initialVC.managedObjectContext=self.managedObjectContext;
    initialVC.userContext=self.userContext;
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
    NSLog(@"in piclistmaintableloaloa viewdidload");
    /*if (managedObjectContext == nil)
    {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"managedobjectcontext set");

    }
    if (managedObjectContext == nil)
    {
        NSLog(@"managedobjectcontext nill");

    }
    managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    managedObjectContext=[[AppDelegate sharedAppDelegate] managedObjectContext];
    */
    //managedObjectModel=[[AppDelegate sharedAppDelegate] managedObjectModel];

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
