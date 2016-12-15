//
//  NSString+Sha1.m
//  PollutionMonitor
//
//  Created by Demian Turner on 15/12/2016.
//  Copyright © 2016 Seagull Systems. All rights reserved.
//

#import "NSString+Sha1.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Sha1)
- (NSString *)sha1Hash
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data sha1Hash];
    return [hash hexString];
}
@end

@implementation NSData (Sha1)
- (NSString *)hexString
{
    NSUInteger bytesCount = self.length;
    if (bytesCount) {
        static char const *kHexChars = "0123456789ABCDEF";
        const unsigned char *dataBuffer = self.bytes;
        char *chars = malloc(sizeof(char) * (bytesCount * 2 + 1));
        char *s = chars;
        for (unsigned i = 0; i < bytesCount; ++i) {
            *s++ = kHexChars[((*dataBuffer & 0xF0) >> 4)];
            *s++ = kHexChars[(*dataBuffer & 0x0F)];
            dataBuffer++;
        }
        *s = '\0';
        NSString *hexString = [NSString stringWithUTF8String:chars];
        free(chars);
        return hexString;
    }
    return @"";
}
- (NSData *)sha1Hash
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    if (CC_SHA1(self.bytes, (CC_LONG)self.length, digest)) {
        return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    }
    return nil;
}
@end
