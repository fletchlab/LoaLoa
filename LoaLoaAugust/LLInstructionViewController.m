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
#import <AudioToolbox/AudioToolbox.h>


@interface LLInstructionViewController ()

@end

@implementation LLInstructionViewController

@synthesize userContext;
@synthesize managedObjectContext;
@synthesize scrollView;
AVAudioPlayer *player;


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
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    OSStatus err = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                                           sizeof(sessionCategory),
                                           &sessionCategory);
    AudioSessionSetActive(TRUE);
    if (err) {
        NSLog(@"AudioSessionSetProperty kAudioSessionProperty_AudioCategory failed: %ld", err);
    }
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"somethingwrong" ofType: @"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL error: nil];
    
    [player setVolume: 1];    // available range is 0.0 through 1.0
    [player play];

     

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
    else /*if([segue.identifier isEqualToString:@"NextInstruction"]) */{
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
