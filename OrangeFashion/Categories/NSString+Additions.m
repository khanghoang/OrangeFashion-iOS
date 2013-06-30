//
//  NSString+Additions.m
//  Aurora
//
//  Created by Daud Abas on 24/2/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import <time.h>
#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "ISO8601DateFormatter.h"

@implementation NSString (Additions)

- (NSUInteger)wordCount {
  NSScanner *scanner = [NSScanner scannerWithString: self];
  NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  
  NSUInteger count = 0;
  while ([scanner scanUpToCharactersFromSet: whiteSpace  intoString: nil])
    count++;
  
  return count;
}

- (BOOL)contains:(NSString*)needle {
  NSRange range = [self rangeOfString:needle options: NSCaseInsensitiveSearch];
  return (range.length == needle.length && range.location != NSNotFound);
}

- (BOOL)startsWith:(NSString*)needle {
  NSRange range = [self rangeOfString:needle options: NSCaseInsensitiveSearch];
  return (range.length == needle.length && range.location == 0);
}

- (BOOL)endsWith:(NSString*)needle {
  NSRange range = [self rangeOfString:needle options: NSCaseInsensitiveSearch];
  return (range.length == needle.length && range.location == (self.length-range.length-1));
}

- (NSString*)URLEncodedString
{
  __autoreleasing NSString *encodedString;
  
  NSString *originalString = (NSString *)self;    
  encodedString = (__bridge_transfer NSString * )
  CFURLCreateStringByAddingPercentEscapes(NULL,
                                          (__bridge CFStringRef)originalString,
                                          (CFStringRef)@"$-_.+!*'(),&+/:;=?@#",
                                          NULL,
                                          kCFStringEncodingUTF8);
  encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%25" withString:@"\%"];   //revert double escape
  return encodedString;
}

- (NSString*)URLEncodeEverything
{
    __autoreleasing NSString *encodedString;
    
    NSString *originalString = (NSString *)self;    
    encodedString = (__bridge_transfer NSString * )
    CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (__bridge CFStringRef)originalString,
                                            NULL,
                                            (CFStringRef)@"$-_.+!*'(),&+/:;=?@#",
                                            kCFStringEncodingUTF8);
    encodedString = [encodedString stringByReplacingOccurrencesOfString:@"%25" withString:@"\%"];   //revert double escape
    return encodedString;
}


- (NSString *)sha1 {
  const char *cStr = [self UTF8String];
  unsigned char result[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1(cStr, strlen(cStr), result);
  NSString *s = [NSString  stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3], result[4],
                 result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12],
                 result[13], result[14], result[15],
                 result[16], result[17], result[18], result[19]
                 ];
  
  return s;
}

- (NSString *)md5 {
  const char *cStr = [self UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(cStr, strlen(cStr), result);
  NSString *s = [NSString  stringWithFormat:
                 @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3], result[4],
                 result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12],
                 result[13], result[14], result[15]
                 ];
  
  return s;
}

- (NSDate*)dateFromString
{
  static ISO8601DateFormatter *dateFormatter = nil;
  if (dateFormatter == nil)
    dateFormatter = [[ISO8601DateFormatter alloc] init];

  NSDate *theDate = [dateFormatter dateFromString:self];
  return theDate;
}

+ (NSString*)facebookUserProfileImageUrlWithId:(NSNumber*)fbID
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", fbID];
}
@end
