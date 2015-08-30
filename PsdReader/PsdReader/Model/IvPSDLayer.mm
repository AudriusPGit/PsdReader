//
//  IvPSDLayer.m
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import "IvPSDLayer.h"
#import "IvParseUtils.h"

//----------------------------------------------------------------------
//-------------- IvPSDLayerChannel
//----------------------------------------------------------------------
@implementation IvPSDLayerChannel : NSObject

-(instancetype) initWithChannelId:(int) channelID size:(int)size
{
    self.channelId = channelID;
    self.channelSize = size;
    
    return self;
}

+(instancetype) createWithChannelId:(int) channelID size:(int)size
{
    IvPSDLayerChannel *channel = [[IvPSDLayerChannel alloc] initWithChannelId:channelID size:size];
    
    return channel;
}

@end

//----------------------------------------------------------------------
//-------------- IvPSDLayer
//----------------------------------------------------------------------
@interface IvPSDLayer()
{
    NSMutableArray *_channels;
}
@end


@implementation IvPSDLayer

@synthesize name = _name;

-(instancetype) initWithStream:(NSInputStream*) stream
{
    _channels = [[NSMutableArray alloc] init];
    
    [self parseRecordFromStream:stream];
    [self parseImageDataFromStream:stream];
    
    return self;
}

-(void) parseRecordFromStream:(NSInputStream *) stream
{
    u_int32_t lenght = ParseUtils::read4ByteUInt(stream);
    NSLog(@"lenght: %u", lenght);
    
    {//layer info
        u_int32_t lenght = ParseUtils::read4ByteUInt(stream);
        NSLog(@"lenght: %u", lenght);
        
        {//record
            u_int32_t layerCount = ParseUtils::read2ByteUInt(stream);
            NSLog(@"layerCount: %u", layerCount);
            
            u_int8_t layerContent[16];
            [stream read:layerContent maxLength:16];
            NSLog(@"layerContent:");
            
            u_int16_t channelNum = ParseUtils::read2ByteUInt(stream);
            NSLog(@"channelNum: %hu", channelNum);
            
            for(int i = 0; i < channelNum; ++i)
            {
                int16_t channelID = ParseUtils::read2ByteSInt(stream);
                u_int32_t channelSize = ParseUtils::read4ByteUInt(stream);
                
                NSLog(@"channelID %d, size %d bytes", channelID, channelSize);
                
                IvPSDLayerChannel *channel = [IvPSDLayerChannel createWithChannelId:channelID size:channelSize];
                [_channels addObject:channel];
            }
            
            //            skip(stream, 6 * channelNum);
            //            NSLog(@"skip channel information data: %d bytes", 6 * channelNum);
            
            NSString *blendModeSignature = ParseUtils::readString(stream, 4);
            NSLog(@"blendModeSignature: %@", blendModeSignature);
            
            NSString *blendModeKey = ParseUtils::readString(stream, 4);
            NSLog(@"blendModeKey: %@", blendModeKey);
            
            u_int8_t opacity = ParseUtils::read1ByteUInt(stream);
            NSLog(@"opacity: %hhu", opacity);
            
            u_int8_t clipping = ParseUtils::read1ByteUInt(stream);
            NSLog(@"clipping: %hhu", clipping);
            
            u_int8_t flags = ParseUtils::read1ByteUInt(stream);
            NSLog(@"flags: %hhu", flags);
            
            u_int8_t filler = ParseUtils::read1ByteUInt(stream);
            NSLog(@"filler: %hhu", filler);
            
            u_int32_t extraBytesLength = ParseUtils::read4ByteUInt(stream);
            u_int32_t remainingBytes = extraBytesLength;
            
            NSLog(@"extraBytesLength: %u", extraBytesLength);
            
            
            {//layer mask data
                u_int32_t lenght = ParseUtils::read4ByteUInt(stream);
                remainingBytes -= 4;
                NSLog(@"lenght: %u", lenght);
                
                ParseUtils::skip(stream, lenght);
                remainingBytes -= lenght;
                NSLog(@"skip layer mask data: %d bytes", lenght);
            }
            
            {//layer blending data
                u_int32_t lenght = ParseUtils::read4ByteUInt(stream);
                remainingBytes -= 4;
                NSLog(@"lenght: %u", lenght);
                
                ParseUtils::skip(stream, lenght);
                remainingBytes -= lenght;
                NSLog(@"skip layer blending data: %d bytes", lenght);
            }
            
            {//<layer name
                u_int8_t lenght = ParseUtils::read1ByteUInt(stream);
                remainingBytes -= 1;
                NSLog(@"lenght: %u", lenght);
                
                _name = ParseUtils::readString(stream, lenght);
                remainingBytes -= lenght;
                NSLog(@"name: %@", _name);
                
                u_int8_t extraBytes = (lenght + 1) % 4;
                u_int8_t paddingBytes = (4 - extraBytes) % 4;
                
                ParseUtils::skip(stream, paddingBytes);
                remainingBytes -= paddingBytes;
                NSLog(@"skip padding %d bytes", paddingBytes);
                
                ParseUtils::skip(stream, remainingBytes);
                NSLog(@"skip remaining %d bytes", remainingBytes);
                
                remainingBytes -= remainingBytes;
            }
        }//record
        
    }//layer info
}

- (char*)PackBitsRLEDecder:(NSInputStream*) stream : (char *)buffer
{
    const int hackedHeight = 480;
    const int hackedWidth = 320;
    
    u_int16_t lineLengths[hackedHeight];
    
    for (int i = 0; i < hackedHeight; ++i)
    {
        uint16_t lineLength = ParseUtils::read2ByteUInt(stream);
        NSLog(@"%d lineLength: %d", i, lineLength);
        lineLengths[i] = lineLength;
    }
    
    
    char *s = (char *)[[NSMutableData dataWithLength:sizeof(char) * (hackedWidth * 2)] mutableBytes];
    
    int pos = 0;
    int lineIndex = 0.f * hackedHeight;
    
    for (uint32_t i = 0; i < hackedHeight; ++i)
    {
        uint16_t len = lineLengths[lineIndex++];
        
        [stream read:(uint8_t*)s maxLength:len];
        NSLog(@"%d %s", i, s);
        
        ParseUtils::PackBitsRLE(s, 0, len, buffer, pos);
        pos += hackedWidth;
    }
    
    return buffer;
}


-(void) parseImageDataFromStream:(NSInputStream*) stream
{
    const int hackedHeight = 480;
    const int hackedWidth = 320;
    
    char *alpha = (char *)[[NSMutableData dataWithLength:sizeof(char) * (hackedWidth * hackedHeight)] mutableBytes];
    char *red = (char *)[[NSMutableData dataWithLength:sizeof(char) * (hackedWidth * hackedHeight)] mutableBytes];
    char *green = (char *)[[NSMutableData dataWithLength:sizeof(char) * (hackedWidth * hackedHeight)] mutableBytes];
    char *blue = (char *)[[NSMutableData dataWithLength:sizeof(char) * (hackedWidth * hackedHeight)] mutableBytes];
    
    
    for(IvPSDLayerChannel *channel : _channels)
    {
        const int channelID = channel.channelId;
        //        const int channelSize = channel.channelSize;
        
        u_int16_t encoding = ParseUtils::read2ByteUInt(stream);
        NSLog(@"encoding: %u", encoding);
        
        switch (channelID)
        {
            case -1: //<alpha
            {
                [self PackBitsRLEDecder:stream : &*alpha];
            }
                break;
            case 0://<red
            {
                [self PackBitsRLEDecder:stream : &*red];
            }
                break;
            case 1://<green
            {
                [self PackBitsRLEDecder:stream : &*green];
                
            }
                break;
            case 2://blue
            {
                [self PackBitsRLEDecder:stream : &*blue];
            }
                break;
                
            default:
                break;
        }
    }
    
    int pixelDataSize = hackedHeight * hackedWidth * 4;
    int *pixels = (int *)malloc(pixelDataSize);
    
    for(int h = 0; h < (hackedHeight * hackedWidth) - 4; ++h)
    {
        pixels[h + 0] = (u_int8_t)red[h];
        pixels[h + 1] = (u_int8_t)green[h];
        pixels[h + 2] = (u_int8_t)blue[h];
        pixels[h + 3] = (u_int8_t)alpha[h];
    }
    
    CGContextRef ctx = CGBitmapContextCreate(pixels, hackedWidth, hackedHeight, 8, hackedWidth * 4.f, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    
    CGImageRef bitmapImage = CGBitmapContextCreateImage(ctx);
    _image = [UIImage imageWithCGImage:bitmapImage];
    
    CGContextRelease(ctx);
}

+(instancetype) createFromStream:(NSInputStream*) stream
{
    IvPSDLayer *layer = [[IvPSDLayer alloc] initWithStream:stream];
    
    return layer;
}

@end