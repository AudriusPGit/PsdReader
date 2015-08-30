//
//  IvPSDDocument.h
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//


@class IvPSDHeader;
@class IvPSDLayer;

//----------------------------------------------------------------------
//-------------- IvPSDDocument
//----------------------------------------------------------------------
@interface IvPSDDocument : UIDocument

@property (nonatomic, readonly) IvPSDHeader *header;
@property (nonatomic, readonly) IvPSDLayer *layer;

+(instancetype) createFromFileName:(NSString*) fileName;

@end