//
//  LoginViewController.m
//  CellScope
//
//  Created by Matthew Bakalar on 8/19/12.
//  Copyright (c) 2012 Matthew Bakalar. All rights reserved.
//

#import "LLLoginViewController.h"
#import "LLMainMenuViewController.h"
#import "PictureListMainTable.h"
#import "CoreDataHelper.h"
#import "CSUserContext.h"

@interface LLLoginViewController ()

@end

@implementation LLLoginViewController

@synthesize managedObjectContext;
@synthesize usernameField;
@synthesize passwordField;

- (IBAction)resignAndLogin:(id)sender
{
    // Get a reference to the text field on whcih the done button was pressed
    UITextField *tf = (UITextField *)sender;
    
    // Check the tag. If this is the username field, jump to the password field
    if (tf.tag == 1) {
        [passwordField becomeFirstResponder];
    }
    // Otherwise we pressed done on the password field, and want to attempt login
    else {
        [sender resignFirstResponder];
        // Setup the search criteria for checking whether password is correct
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(username == %@ && password == %@)", usernameField.text, passwordField.text];
        if([CoreDataHelper countForEntity:@"Users" withPredicate:pred andContext:self.managedObjectContext] > 0) {
            // We found a matching login user! Segue transition to next view
            [self performSegueWithIdentifier:@"LoginSegue" sender:sender];
        }
        else {
            passwordField.text = @"";
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"LoginSegue"]) {
        UINavigationController *navController = (UINavigationController *)[segue destinationViewController];
        LLMainMenuViewController *mainMenu = (LLMainMenuViewController *)[[navController viewControllers] lastObject];
        CSUserContext *userContext = [[CSUserContext alloc] initWithUsername: self.usernameField.text];
    
        // Pass Core Data and CellScope user context to next view
        mainMenu.managedObjectContext = self.managedObjectContext;
        mainMenu.userContext = userContext;
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    usernameField.text = @"";
    passwordField.text = @"";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
        return YES;
    }
    else {
        return NO;
    }
}

@end
