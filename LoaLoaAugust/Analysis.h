//
//  Analysis.h
//  CellScope
//
//  Created by Mike D'Ambrosio on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSUserContext.h"


@interface Analysis : NSObject
{
    NSMutableArray *array;
    NSUInteger numberOfRedPixels;
    NSUInteger maxChangePos;
    }
-(void)addImage: (UIImage *) image;

-(NSMutableArray *)getImageArray;

-(int)analyzeImages;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) CSUserContext *userContext;

@end
