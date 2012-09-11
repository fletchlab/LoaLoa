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
    NSString *soundFilePath;
    if (self.soundNum==0){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"prepare blood sample" ofType: @"wav"];
    }
    else if (self.soundNum==1){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"touch capillary" ofType: @"wav"];

    }
    else if (self.soundNum==2){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"capillary in holder" ofType: @"wav"];
        
    }
    else if (self.soundNum==3){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"capillary is in the sample" ofType: @"wav"];
        
    }
    else if (self.soundNum==4){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"place holder on stage" ofType: @"wav"];
        
    }
    else if (self.soundNum==5){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"prepare to focus" ofType: @"wav"];
        
    }
    else if (self.soundNum>5){
        soundFilePath = [[NSBundle mainBundle] pathForResource: @"move sample" ofType: @"wav"];
        
    }


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
        cvc.repetition=self.repetition;
    }
    else if([segue.identifier isEqualToString:@"NextInstruction"]) {
        // Get a reference to the LLInstruction view controller
        LLInstructionViewController *vc = (LLInstructionViewController*)[segue destinationViewController];
        vc.userContext = self.userContext;
        vc.managedObjectContext = self.managedObjectContext;
        vc.soundNum=self.soundNum+1;
        vc.repetition=self.repetition;
        NSLog(@"repetition is %i",self.repetition);

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

- (IBAction)loopToCapture:(id)sender {
    if(_repetition <= 4) {
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
        CaptureViewControllerLoaLoa *cvc=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"Capture1"];
        cvc.managedObjectContext = self.managedObjectContext;
        cvc.userContext = self.userContext;
        cvc.repetition=self.repetition+1;
        [self presentModalViewController:cvc animated:YES];
    }
    else {
        [self performSegueWithIdentifier:@"ShowResults" sender:self];
    }
}
@end
