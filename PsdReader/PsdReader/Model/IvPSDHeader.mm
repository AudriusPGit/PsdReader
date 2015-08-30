//
//  IvPSDHeader.m
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import "IvPSDHeader.h"
#import "IvParseUtils.h"

//----------------------------------------------------------------------
//-------------- IvPSDHeader
//----------------------------------------------------------------------
@implementation IvPSDHeader : NSObject

-(instancetype) initWithStream:(NSInputStream*) stream
{
    _signature = ParseUtils::readString(stream, 4);
    NSLog(@"signature: %@", _signature);
    
    _version= ParseUtils::read2ByteUInt(stream);
    NSLog(@"version: %hhu", _version);
    
    ParseUtils::skip(stream, 6);
    NSLog(@"skip reserved: %d bytes", 6);
    
    _channels = ParseUtils::read2ByteUInt(stream);
    NSLog(@"channels: %hhu", _channels);
    
    _height = ParseUtils::read4ByteUInt(stream);
    NSLog(@"height: %u", _height);
    
    _width = ParseUtils::read4ByteUInt(stream);
    NSLog(@"width: %u", _width);
    
    _depth = ParseUtils::read2ByteUInt(stream);
    NSLog(@"depth: %hu", _depth);
    
    _colorMode = ParseUtils::read2ByteUInt(stream);
    NSLog(@"colorMode: %hu", _colorMode);
    
    return self;
}

+(instancetype) createFromStream:(NSInputStream*) stream
{
    IvPSDHeader *header = [[IvPSDHeader alloc] initWithStream:stream];
    return header;
}

@end