//
//  CaptureViewControllerLoaLoa.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/30/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "CaptureViewControllerLoaLoa.h"
#import "UIImage+Resize.h"
#import "Pictures.h"
#import "CSUserContext.h"
#import <ImageIO/ImageIO.h>
#import "Analysis.h"


@interface CaptureViewControllerLoaLoa ()

@end

@implementation CaptureViewControllerLoaLoa
@synthesize stillOutput;
@synthesize progressBar;
@synthesize loaLoaCounter;
NSTimer *myTimer;
int i;
//@synthesize previewLayer;
// Hello world, comment
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
    //progressBar.frame = CGRectMake(20, 20, 200, 15);
    //[previewLayer addSubview:progressBar];
    //[self.view bringSubviewToFront:progressBar];
    //UIProgressView *progressBar = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
    
    progressBar.progress = 0.0;
    
	// Do any additional setup after loading the view.
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [self setProgressBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(IBAction) captureImages:(id)sender
{
    [progressBar setProgress:0.0];
    i=1;
    loaLoaCounter=[[Analysis alloc] init];
    myTimer= [NSTimer scheduledTimerWithTimeInterval: .75 target: self
                                                      selector: @selector(captureImage:) userInfo: nil repeats: YES];
    }


-(void) captureImage:(NSTimer*) t
{
    if (i==5){
        [myTimer invalidate];
        myTimer=nil;
    }

    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in stillOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
    
	NSLog(@"about to request a capture from: %@", stillOutput);
	[stillOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if (CMSampleBufferIsValid(imageSampleBuffer)){
             CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
             if (exifAttachments)
             {
                 // Do something with the attachments.
                 NSLog(@"attachements: %@", exifAttachments);
             }
             else
                 NSLog(@"no attachments");
             NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             UIImage *image = [[UIImage alloc] initWithData:imageData];
             [loaLoaCounter addImage:image];
             UIImage* thumbnail = [image thumbnailImage:80.0 transparentBorder:1.0 cornerRadius:1.0 interpolationQuality:kCGInterpolationDefault];
             
             // Set the last captured image preview thumbnail
             self.lastCaptured.image = thumbnail;
             
             // Save the image to the camera roll
             if ([self.userContext.sharing isEqualToString:@"Camera Roll"]) {
                 // Request to save the image to camera roll
                 UIImageWriteToSavedPhotosAlbum(image, self,
                                                @selector(image:didFinishSavingWithError:contextInfo:), nil);
             }
             
             // If we are adding a new picture then create an entry
             Pictures* picture = (Pictures *)[NSEntityDescription insertNewObjectForEntityForName:@"Pictures" inManagedObjectContext:self.managedObjectContext];
             
             // Set the picture properties
             picture.title = @"Default";
             picture.desc = @"No description";
             picture.date = [NSDate date];
             picture.user = self.userContext.username;
             picture.sharing = self.userContext.sharing;
             picture.smallPicture = UIImagePNGRepresentation(thumbnail);
             
             if (![self.managedObjectContext save:&error]) {
                 NSLog(@"Failed to add new picture with error: %@", [error domain]);
             }
             
             [progressBar setProgress:progressBar.progress+0.2];
             
         }
         
     }];
    i=i+1;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
