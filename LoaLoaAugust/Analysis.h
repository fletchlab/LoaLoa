//
//  Analysis.h
//  CellScope
//
//  Created by Mike D'Ambrosio on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Analysis : NSObject
{
    NSMutableArray *array;
    NSUInteger numberOfRedPixels;
    NSUInteger maxChangePos;
}
-(void)addImage: (UIImage *) image;

-(NSMutableArray *)getImageArray;

-(int)analyzeImages;
@end
