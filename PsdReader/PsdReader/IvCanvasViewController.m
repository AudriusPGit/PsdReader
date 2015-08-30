//
//  IvCanvasViewController.m
//  psdViewer
//
//  Created by Brolis on 8/29/15.
//  Copyright (c) 2015 psd. All rights reserved.
//

#import "IvCanvasViewController.h"

@implementation IvCanvasViewController


-(instancetype) initWithUIImage:(UIImage*) image
{
    self = [super init];
    
    if(self)
    {
        self.view = [[UIImageView alloc] initWithImage:image];
        self.title = @"Canvas";
    }
    
    return self;
}

@end
