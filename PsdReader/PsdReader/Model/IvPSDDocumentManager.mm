//
//  IvPSDDocumentManager.m
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import "IvPSDDocumentManager.h"
#import "IvPSDDocument.h"

IvPSDDocumentManager *pManager = NULL;


@interface IvPSDDocumentManager()
{
    NSMutableArray *_documentArray;
}
@end;


@implementation IvPSDDocumentManager

-(id) init
{
    self = [super init];
    
    if(self)
    {
        _documentArray = [[NSMutableArray alloc] init];
        [_documentArray addObject:[IvPSDDocument createFromFileName:@"HireMe"]];
    }
    
    return self;
}

-(IvPSDDocument*) getDocumentAtIndex:(int) index
{
    return [_documentArray objectAtIndex:index];
}

-(int) getDocumentsSize
{
    return [_documentArray count];
}

+(instancetype) instance
{
    if(!pManager)
    {
        pManager = [[IvPSDDocumentManager alloc] init];
    }
    
    return pManager;
}

@end