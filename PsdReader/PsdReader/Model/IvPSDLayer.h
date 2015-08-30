//
//  IvPSDLayer.h
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------------------
//-------------- IvPSDLayerChannel
//----------------------------------------------------------------------
@interface IvPSDLayerChannel : NSObject

@property(nonatomic) int channelId;
@property(nonatomic)  int channelSize;

+(instancetype) createWithChannelId:(int) channelID size:(int)size;
@end

//----------------------------------------------------------------------
//-------------- IvPSDLayer
//----------------------------------------------------------------------
@interface IvPSDLayer : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, strong, readonly) UIImage *image;

+(instancetype) createFromStream:(NSInputStream*) stream;

@end