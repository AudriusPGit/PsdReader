//
//  IvPSDHeader.h
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import <UIKit/UIKit.h>

//----------------------------------------------------------------------
//-------------- IvPSDHeader
//----------------------------------------------------------------------
@interface IvPSDHeader : NSObject

@property(nonatomic, readonly) NSString* signature;
@property(nonatomic, readonly) u_int8_t version;
@property(nonatomic, readonly) u_int8_t channels;
@property(nonatomic, readonly) u_int32_t width;
@property(nonatomic, readonly) u_int32_t height;
@property(nonatomic, readonly) u_int16_t depth;
@property(nonatomic, readonly) u_int16_t colorMode;

+(instancetype) createFromStream:(NSInputStream*) stream;

@end