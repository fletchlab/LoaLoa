//
//  CaptureViewControllerLoaLoa.h
//  LoaLoaAugust
//
//  Created by Mike D'Ambrosio on 8/30/12.
//  Copyright (c) 2012 Mike D'Ambrosio. All rights reserved.
//

#import "CaptureViewController.h"
#import "Analysis.h"

@interface CaptureViewControllerLoaLoa : CaptureViewController
@property Analysis *loaLoaCounter;


@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;



@end
