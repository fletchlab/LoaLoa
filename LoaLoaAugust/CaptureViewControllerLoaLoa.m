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
#import <AssetsLibrary/AssetsLibrary.h>
#import "ReviewViewController.h"



@interface CaptureViewControllerLoaLoa ()

@end

@implementation CaptureViewControllerLoaLoa
@synthesize stillOutput;
@synthesize progressBar;
@synthesize loaLoaCounter;
@synthesize input;
@synthesize videoPreviewOutput, videoHDOutput;
@synthesize assetWriter;
@synthesize pixelBufferAdaptor ;
@synthesize assetWriterInput;
@synthesize outputURL;
BOOL recording=FALSE;
int frameNumber=0;
int arraySize=0;
UIImage *analyzedImage;



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
    progressBar.progress = 0.0;
    
    //[super viewDidLoad];
	
    /*// Setup the AV foundation capture session
     self.session = [[AVCaptureSession alloc] init];
     self.session.sessionPreset = AVCaptureSessionPresetPhoto;
     
     self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
     self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
     
     // Setup image preview layer
     CALayer *viewLayer = self.previewLayer.layer;
     AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.session];
     
     captureVideoPreviewLayer.frame = viewLayer.bounds;
     [viewLayer addSublayer:captureVideoPreviewLayer];
     
     // Setup still image output
     self.stillOutput = [[AVCaptureStillImageOutput alloc] init];
     NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
     [self.stillOutput setOutputSettings:outputSettings];
     */
    
    // Add session input and output
    //[self.session addInput:self.input];
    //[self.session addOutput:self.stillOutput];
    
    //[self.session startRunning];
    
    
    
    // Setup input and output devices
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    
    // Lock the focus
    BOOL focusSupported = [input.device isFocusModeSupported:AVCaptureFocusModeLocked] &
    [input.device lockForConfiguration:nil];
    
    if (focusSupported) {
        [input.device setFocusMode:AVCaptureFocusModeLocked];
        [input.device unlockForConfiguration];
    }
    
    self.VideoHDOutput = [[AVCaptureVideoDataOutput alloc] init];
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [self.videoHDOutput setSampleBufferDelegate:self queue:queue];
    dispatch_release(queue);
    
    
    // Process frames while dispatch queue is occupied?
    self.videoHDOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // Set the pixel type for the captured video
    NSString* key = (NSString*) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [self.videoHDOutput setVideoSettings:videoSettings];
    
    // Create the capture session
    self.session = [[AVCaptureSession alloc] init];
    
    //set up the preview layer
    // Setup image preview layer
    CALayer *viewLayer = self.previewLayer.layer;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession: self.session];
    
    captureVideoPreviewLayer.frame = viewLayer.bounds;
    [viewLayer addSublayer:captureVideoPreviewLayer];
    
    
    // Add input and output to the session
    [self.session addInput:input];
    [self.session addOutput:videoHDOutput];
    
    //Set frame rate (if requried)
    AVCaptureConnection *captureConnection = [videoHDOutput connectionWithMediaType:AVMediaTypeVideo];
	CMTimeShow(captureConnection.videoMinFrameDuration);
	CMTimeShow(captureConnection.videoMaxFrameDuration);
	if (captureConnection.supportsVideoMinFrameDuration)
		captureConnection.videoMinFrameDuration = CMTimeMake(1, 30);
	if (captureConnection.supportsVideoMaxFrameDuration)
		captureConnection.videoMaxFrameDuration = CMTimeMake(1, 30);
    CMTimeShow(captureConnection.videoMinFrameDuration);
    CMTimeShow(captureConnection.videoMaxFrameDuration);
    
    
    // Set capture quality
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    //Check size based configs are supported before setting them
    //if ([captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
    //    [captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    if([self.session canSetSessionPreset:AVCaptureSessionPreset640x480])
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    
    /* set the video output to 1280x720 or 640x480 in H.264, via an asset writer */
    //720p on iphone4 is way to slow
    NSDictionary *outputSettings;
    /*if ([captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]){
     
     outputSettings =
     [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithInt:1280], AVVideoWidthKey,
     [NSNumber numberWithInt:720], AVVideoHeightKey,
     AVVideoCodecH264, AVVideoCodecKey,
     nil];
     }*/
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]){
        outputSettings =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithInt:640], AVVideoWidthKey,
         [NSNumber numberWithInt:480], AVVideoHeightKey,
         AVVideoCodecH264, AVVideoCodecKey,
         nil];
        
    }
    //set up the assetwriter input
    assetWriterInput = [AVAssetWriterInput
                        assetWriterInputWithMediaType:AVMediaTypeVideo
                        outputSettings:outputSettings];
    
    // set up the AVAssetWriterPixelBufferAdaptor to expect 32BGRA input
    pixelBufferAdaptor =
    [[AVAssetWriterInputPixelBufferAdaptor alloc]
     initWithAssetWriterInput:assetWriterInput
     sourcePixelBufferAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [NSNumber numberWithInt:kCVPixelFormatType_32BGRA],
      kCVPixelBufferPixelFormatTypeKey,
      nil]];
    
    //set out file url
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath])
    {
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO)
        {
            NSLog(@"output error");
        }
    }
    /*set the input so that it tries to avoid being unavailable at inopportune moments as it is going in real time */
    assetWriterInput.expectsMediaDataInRealTime = YES;
    
    [self.session startRunning];
    
}



- (void) captureOutput:(AVCaptureOutput *)captureOutput
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection
{
    // NSLog(@"in sample buffer delegate");
    
    if (recording==TRUE){
        NSLog(@"recording %i", frameNumber);
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        //NSLog(@"in capture output");
        //add current imageBuffer to our pixelbufferadaptor
        //static int64_t frameNumber = 0;
        if(assetWriterInput.readyForMoreMediaData){
            //NSLog(@"adding imagebuffer %i",frameNumber);
            [pixelBufferAdaptor appendPixelBuffer:imageBuffer
                             withPresentationTime:CMTimeMake(frameNumber, 30)];
        }
        
        if ((frameNumber % 30)==0 && frameNumber<=120){
            //this block puts the current image buffer into NSData.  Right now, stick with converting it to UIImage
            /*
             //get the byte data from sampleBuffer in an NSData
             CVPixelBufferLockBaseAddress(imageBuffer, 0);
             size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
             //size_t width = CVPixelBufferGetWidth(imageBuffer);
             size_t height = CVPixelBufferGetHeight(imageBuffer);
             void *src_buff = CVPixelBufferGetBaseAddress(imageBuffer);
             
             NSData *data = [NSData dataWithBytes:src_buff length:bytesPerRow * height];
             [analysis_object addImage:curr_image];
             
             UIImage *curr_image = [self imageFromSampleBuffer:sampleBuffer];
             
             CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
             */
            UIImage *curr_image = [self imageFromSampleBuffer:sampleBuffer];
            //[progressBar setProgress:progressBar.progress+0.2];
            [self performSelectorInBackground:@selector(updateProgress) withObject:nil];
            
            //[[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
            
            
            
            arraySize=[loaLoaCounter addImage:curr_image];
            if (frameNumber==120)  {
                
                
                recording=FALSE;
                [self finishVideo];
                NSLog(@"done recording");
                analyzedImage=[loaLoaCounter analyzeImages];

                
            }

        }
        
        frameNumber++;
        
        
    }
}
-(void) updateProgress{
    [progressBar setProgress:progressBar.progress+0.12];
    
}
- (void) finishVideo{
    NSLog(@"stop recording");
    if(!recording) {
        recording=FALSE;
        [assetWriter finishWriting];
        ALAssetsLibrary * library = [[ALAssetsLibrary alloc] init];
        
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL
                                        completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 if (error)
                 {
                     NSLog(@"error writing");
                 }
             }];
        }
    }
}

/*- (void)viewDidLoad
 {
 //progressBar.frame = CGRectMake(20, 20, 200, 15);
 //[previewLayer addSubview:progressBar];
 //[self.view bringSubviewToFront:progressBar];
 //UIProgressView *progressBar = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
 
 progressBar.progress = 0.0;
 
 // Do any additional setup after loading the view.
 [super viewDidLoad];
 
 }*/

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
    loaLoaCounter.userContext = self.userContext;
    loaLoaCounter.managedObjectContext = self.managedObjectContext;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(eventHandler:)
     name:@"eventType"
     object:nil ];
    
    
    
    myTimer= [NSTimer scheduledTimerWithTimeInterval: .75 target: self
                                            selector: @selector(captureImage:) userInfo: nil repeats: YES];
}


-(void)eventHandler: (NSNotification *) notification
{
    NSLog(@"notification from analysis");

    [self performSelectorInBackground:@selector(updateProgress) withObject:nil];
    
}

-(IBAction) captureMovie:(id)sender
{
    NSLog(@"record button pressed");
    if(!recording) {
        NSLog(@"start recording");
        arraySize=0;
        [progressBar setProgress:0.0];
        loaLoaCounter=[[Analysis alloc] init];
        //tell the delegate to start listening to the video output
        loaLoaCounter.userContext = self.userContext;
        loaLoaCounter.managedObjectContext = self.managedObjectContext;
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(eventHandler:)
         name:@"eventType"
         object:nil ];
        
        
        
        recording=TRUE;
        
        //reset the frame number
        frameNumber=0;
        //create our analysis object to which we will send data
        
        //delete files in temp folder
        NSFileManager* fileManager = [NSFileManager defaultManager];
        // get all files in the temp folder
        NSArray* files = [fileManager   contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
        // delete
        for (int i=0; i<[files count]; i++)
        {
            NSString* fileName = [files objectAtIndex:i];
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), fileName] error:nil];
        }
        
        //create assetwriter H.264 within the normal MPEG4 container
        assetWriter = [[AVAssetWriter alloc]
                       initWithURL:outputURL
                       fileType:
                       AVFileTypeMPEG4
                       error:nil
                       ];
        [assetWriter addInput:assetWriterInput];
        
        
        [assetWriter startWriting];
        [assetWriter startSessionAtSourceTime:kCMTimeZero];
    }
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"in didfinishsaving");

    if (arraySize==5)
        {
            analyzedImage=[loaLoaCounter analyzeImages];
        }

    // Handle error saving image to camera roll
    if (error != NULL) {
        NSLog(@"Error saving picture to camera rolll");
    }
}


- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

- (IBAction)closeCapture:(id)sender {
    // Close the AV Capture session
    [self.session stopRunning];
    
    [self performSegueWithIdentifier:@"Review" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /*
     UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"LoaLoaStoryboard" bundle:nil];
     ReviewViewController *review=[MainStoryboard instantiateViewControllerWithIdentifier:(NSString *)@"Review"];
     //NSArray *viewControllerArray = [initialMainViewController viewControllers];
     //PictureListMainTableLoaLoa *initialVC=[viewControllerArray objectAtIndex:0];
     */
    
    ReviewViewController* rvc = (ReviewViewController*)[segue destinationViewController];
    
    rvc.managedObjectContext=self.managedObjectContext;
    rvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    rvc.differenceImage=analyzedImage;
    
    rvc.numContoursReview=[loaLoaCounter getNumContours];
    NSLog(@"from closeCapture numcontours=%i",[loaLoaCounter getNumContours] );

    //[self presentModalViewController:rvc animated:YES];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
