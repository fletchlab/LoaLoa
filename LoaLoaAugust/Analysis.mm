//
//  Analysis.m
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 9/4/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//


#import "Analysis.h"
#import "UIImage+OpenCV.h"
#import "CSUserContext.h"
#import "Pictures.h"
#import "UIImage+Resize.h"
#import <AssetsLibrary/AssetsLibrary.h>





@implementation Analysis
UIImage *outImagebwopen;
int numContoursLast=1;


-(id)init
{
    self=[super init];
    if (self!=nil){
        array = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(int)addImage: (UIImage*) image{
    [array addObject: image];
    return [array count];
    //if ([array count]==5)
        //[self analyzeImages];
    
}

-(NSMutableArray *)getImageArray{
	return array;
}


- (UIImage *) analyzeImages{
    int numContours=0;
    
    NSLog(@"analyzing images");
    if ([array count]>0){
        
        for(int y=1; y<[array count]; y++){
            //double t;
            //int times = 1;
            UIImage *image=[array objectAtIndex:(NSUInteger)y-1];
            
            UIImage *image2=[array objectAtIndex:(NSUInteger)y];
            // Convert from UIImage to cv::Mat
            //t = (double)cv::getTickCount();
            
            cv::Mat tempMat= [image2 CVMat];
            cv::Mat tempMat2= [image CVMat];
            //t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
            
            //[pool release];
            
            //NSLog(@"UIImage to cv::Mat: %gms", t);
            
            //do processing
            cv::Mat dst(tempMat.size(), tempMat.type());
            cv::absdiff(tempMat, tempMat2, dst);
            
            //colormap
            //cv::Mat(colored);
            //cv::cvtColor(dst, colored, CV_BGR2HSV);
            
            // Convert from cv::Mat to UIImage
            // cv::Mat testMat = [image2 CVMat];
            //t = (double)cv::getTickCount();
            //UIImage *outImage;
            //for (int i = 0; i < times; i++)
            // {
            //    outImage = [[UIImage alloc] initWithCVMat:colored];
            //}
            //t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency() / times;
            //NSLog(@"cv::Mat to UIImage: %gms", t);
            
            //UIImageWriteToSavedPhotosAlbum(outImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            //grayscale mask
            cv::Mat(grayscaled);
            cv::cvtColor(dst, grayscaled, CV_RGB2GRAY );
            cv::Mat(bw);
            //theshold image
            cv::threshold(grayscaled,bw,50,255,CV_THRESH_BINARY);
            //write thresholded image
            //UIImage *outImagebw;
            //outImagebw = [[UIImage alloc] initWithCVMat:bw];
            //UIImageWriteToSavedPhotosAlbum(outImagebw, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            CvMemStorage *storage;
            CvScalar white, black;
            double area;
            black = CV_RGB( 0, 0, 0 );
            white = CV_RGB( 255, 255, 255 );
            IplImage IplBW=bw;
            
            IplImage *input = cvCloneImage(&IplBW);
            
            storage = cvCreateMemStorage(0); // pl.Ensure you will have enough room here.
            CvSeq *contour = NULL;
            int size=100;
            cvFindContours(input, storage, &contour, sizeof (CvContour),
                           CV_RETR_LIST,
                           CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
            
            while(contour)
            {
                area = cvContourArea(contour, CV_WHOLE_SEQ );
                //NSLog(@"area countours: %f", area);
                
                if(area <= size)
                { // removes white dots
                    cvDrawContours( &IplBW, contour, black, black, -1, CV_FILLED, 8 );
                }
                else
                {
                    numContours++;
                    //if( 0 < area && area <= size) // fills in black holes
                    //    cvDrawContours( input, contour, white, white, -1, CV_FILLED, 8 );
                }
                contour = contour->h_next;
            }
            
            cv::Mat imgMat(&IplBW);  //Construct an Mat image "img" out of an IplImage
            outImagebwopen = [[UIImage alloc] initWithCVMat:imgMat];
            //UIImage *grayscaledUIImage;
            //grayscaledUIImage= [[UIImage alloc] initWithCVMat:grayscaled];
            
            CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                                 outImagebwopen.size.width,
                                                                 outImagebwopen.size.height,
                                                                 8, (4 * outImagebwopen.size.width),
                                                                 genericColorSpace,
                                                                 kCGImageAlphaPremultipliedFirst);
            CGColorSpaceRelease(genericColorSpace);
            CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
            CGRect destRect = CGRectMake(0, 0, outImagebwopen.size.width, outImagebwopen.size.height);
            CGContextDrawImage(thumbBitmapCtxt, destRect, outImagebwopen.CGImage);
            CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
            CGContextRelease(thumbBitmapCtxt);
            UIImage *result = [UIImage imageWithCGImage:tmpThumbImage];
            CGImageRelease(tmpThumbImage);
            
            
            
            if (y==4){
                UIImage* thumbnail = [result thumbnailImage:80.0 transparentBorder:1.0 cornerRadius:1.0 interpolationQuality:kCGInterpolationDefault];
                
                UIImageWriteToSavedPhotosAlbum(result, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                // If we are adding a new picture then create an entry
                Pictures* picture = (Pictures *)[NSEntityDescription insertNewObjectForEntityForName:@"Pictures" inManagedObjectContext:self.managedObjectContext];
                if ([self.userContext.sharing isEqualToString:@"Camera Roll"]) {
                    // Request to save the image to camera roll
                    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                    
                    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                        if (error) {
                            NSLog(@"Error writing image to photo album");
                        }
                        else {
                            picture.path = assetURL.absoluteString;
                        }
                    }];
                }
                
                NSString *description= [NSString stringWithFormat:@"%i", numContours];
                
                // Set the picture properties
                picture.title = @"Default";
                picture.desc = description;
                picture.date = [NSDate date];
                picture.user = self.userContext.username;
                picture.sharing = self.userContext.sharing;
                picture.smallPicture = UIImagePNGRepresentation(thumbnail);
                
                //if (![self.managedObjectContext save:&error]) {
                //    NSLog(@"Failed to add new picture with error: %@", [error domain]);
                //}
                numContoursLast=numContours;
                
            }
            NSLog(@"num countours:%i", numContours);
            NSLog(@"analysis complete");
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"eventType"
             object:nil ];
            
            
            cvReleaseMemStorage( &storage ); // deallocate CvSeq as well.
            cvReleaseImage(&input);
        }
    }
    return outImagebwopen ;
}
- (int) getNumContours{
    return numContoursLast;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Unable to save the image
    if (error)
        NSLog(@"error saving image");
    else // All is well
        NSLog(@"image saved in photo album");
}

+ (cv::Mat)cvMatWithImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

int bwareaopen_(IplImage *image, int size)
{
    
    /* OpenCV equivalent of Matlab's bwareaopen.
     image must be 8 bits, 1 channel, black and white
     (objects) with values 0 and 255 respectively */
    
    CvMemStorage *storage;
    CvSeq *contour = NULL;
    CvScalar white, black;
    IplImage *input = NULL; // cvFindContours changes the input
    double area;
    int foundCountours = 0;
    
    black = CV_RGB( 0, 0, 0 );
    white = CV_RGB( 255, 255, 255 );
    
    if(image == NULL || size == 0)
        return(foundCountours);
    
    input = cvCloneImage(image);
    
    storage = cvCreateMemStorage(0); // pl.Ensure you will have enough room here.
    
    cvFindContours(input, storage, &contour, sizeof (CvContour),
                   CV_RETR_LIST,
                   CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
    
    while(contour)
    {
        area = cvContourArea(contour, CV_WHOLE_SEQ );
        if( -size <= area && area <= 0)
        { // removes white dots
            cvDrawContours( image, contour, black, black, -1, CV_FILLED, 8 );
        }
        else
        {
            if( 0 < area && area <= size) // fills in black holes
                cvDrawContours( image, contour, white, white, -1, CV_FILLED, 8 );
        }
        contour = contour->h_next;
    }
    
    cvReleaseMemStorage( &storage ); // deallocate CvSeq as well.
    cvReleaseImage(&input);
    
    return(foundCountours);
    
}


@end