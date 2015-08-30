//
//  IvPSDDocument.m
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import "IvPSDDocument.h"
#import "IvParseUtils.h"
#import "IvPSDHeader.h"
#import "IvPSDLayer.h"

namespace
{
    void printSection(NSString *name)
    {
        NSLog(@"-----------------------------------");
        NSLog(@"------: %@", name);
        NSLog(@"-----------------------------------");
    }
}

//----------------------------------------------------------------------
//-------------- IvPSDDocument
//----------------------------------------------------------------------
@implementation IvPSDDocument

-(instancetype) initFromFileName:(NSString*)fileName
{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"psd"];
    //NSURL *url = [[NSURL alloc] initFileURLWithPath:strPath];
    
    NSInputStream *stream = [NSInputStream inputStreamWithData:[NSData dataWithContentsOfFile:strPath]];
    
    [self parsePsdFromStream:stream];
    
    return self;
}

-(void) parseHeaderFromStream:(NSInputStream*) stream
{
    printSection(@"header");
    _header = [IvPSDHeader createFromStream:stream];
}

-(void) parseColorModeFromStream:(NSInputStream *)stream
{
    printSection(@"colorMode");
    
    u_int32_t lenght = ParseUtils::read4ByteUInt(stream);
    NSLog(@"lenght: %u", lenght);
    
    ParseUtils::skip(stream, lenght);
    NSLog(@"skip color mode data: %d bytes", lenght);
}

-(void) parseImageResourcesFromStream:(NSInputStream *)stream
{
    printSection(@"imageResources");
    
    u_int32_t lenght = ParseUtils::read4ByteUInt(stream);
    NSLog(@"lenght: %u", lenght);
    
    ParseUtils::skip(stream, lenght);
    NSLog(@"skip image resources data: %d bytes", lenght);
}

-(void) parseLayerFromStream:(NSInputStream*) stream
{
    printSection(@"layerAndMask");
    
    _layer = [IvPSDLayer createFromStream:stream];
}

-(void) parsePsdFromStream:(NSInputStream*) stream
{
    [stream open];
    
    [self parseHeaderFromStream:stream];
    [self parseColorModeFromStream:stream];
    
    [self parseImageResourcesFromStream:stream];
    [self parseLayerFromStream:stream];
}

+(instancetype) createFromFileName:(NSString*) fileName
{
    IvPSDDocument *document = [[IvPSDDocument alloc] initFromFileName:fileName];
    
    return document;
}

@end

