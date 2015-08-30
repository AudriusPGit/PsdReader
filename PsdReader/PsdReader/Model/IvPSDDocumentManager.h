//
//  IvPSDDocumentManager.h
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

@class IvPSDDocument;

@interface IvPSDDocumentManager : NSObject

-(IvPSDDocument*) getDocumentAtIndex:(int) index;
-(int) getDocumentsSize;

+(instancetype) instance;

@end