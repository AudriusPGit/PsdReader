//
//  IvParseUtils.m
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//

#import "IvParseUtils.h"
#include <stdlib.h>

namespace ParseUtils
{
    
    NSString *readString(NSInputStream *stream, int length)
    {
        size_t size = sizeof(u_int8_t) * length;
        u_int8_t *buffer = (u_int8_t*)malloc(size);
        [stream read:&buffer[0] maxLength:length];
        
        NSString *string = [[NSString alloc] initWithBytes:buffer length:size encoding:NSASCIIStringEncoding];
        free(buffer);
        
        return string;
    }
    
    void skip(NSInputStream *stream, int length)
    {
        u_int8_t *buffer = (u_int8_t*)malloc(sizeof(u_int8_t) * length);
        [stream read:&buffer[0] maxLength:length];
        free(buffer);
    }
    
    
    u_int8_t read1ByteUInt(NSInputStream *stream)
    {
        u_int8_t value = 0;
        [stream read:&value maxLength:1];
        
        return value;
    }
    
    int16_t read2ByteSInt(NSInputStream *stream)
    {
        u_int8_t buffer[2];
        int16_t value = 0;
        
        [stream read:buffer maxLength:2];
        
        value  = buffer[0] << 8;
        value |= buffer[1];
        
        return value;
    }
    
    u_int16_t read2ByteUInt(NSInputStream *stream)
    {
        u_int8_t buffer[2];
        u_int16_t value = 0;
        
        [stream read:buffer maxLength:2];
        
        value  = buffer[0] << 8;
        value |= buffer[1];
        
        return value;
    }
    
    
    u_int32_t read4ByteUInt(NSInputStream *stream)
    {
        u_int8_t buffer[4];
        u_int32_t value = 0;
        
        [stream read:buffer maxLength:4];
        
        value  = buffer[0] << 24;
        value |= buffer[1] << 16;
        value |= buffer[2] << 8;
        value |= buffer[3];
        
        return value;
    }
    
    void PackBitsRLE(char *src, int sindex, int slen, char *dst, int dindex)
    {
        const int max = sindex + slen;
        
        while (sindex < max)
        {
            char b = src[sindex++];
            
            int n = (int) b;
            
            if (n < 0)
            {
                n = 1 - n;
                b = src[sindex++];
                for (int i = 0; i < n; i++)
                {
                    dst[dindex++] = b;
                }
            }
            else
            {
                n = n + 1;
                
                for (int x = 0; x < n; x++)
                {
                    dst[dindex + x] = src[sindex + x];
                }
                
                dindex += n;
                sindex += n;
            }
        }
    }
}