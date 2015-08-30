//
//  IvParseUtils.h
//  PsdReader
//
//  Created by Brolis on 8/30/15.
//  Copyright (c) 2015 Iv. All rights reserved.
//


#ifndef __psdViewer__psdMathUtils__
#define __psdViewer__psdMathUtils__

namespace ParseUtils
{
    extern NSString *readString(NSInputStream *stream, int length);
    extern void skip(NSInputStream *stream, int length);
    extern u_int8_t read1ByteUInt(NSInputStream *stream);
    
    extern int16_t read2ByteSInt(NSInputStream *stream);
    extern u_int16_t read2ByteUInt(NSInputStream *stream);
    extern u_int32_t read4ByteUInt(NSInputStream *stream);
    extern void PackBitsRLE(char *src, int sindex, int slen, char *dst, int dindex);
}

#endif /* defined(__psdViewer__psdMathUtils__) */