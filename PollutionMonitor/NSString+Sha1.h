//
//  NSString+Sha1.h
//  PollutionMonitor
//
//  Created by Demian Turner on 15/12/2016.
//  Copyright © 2016 Seagull Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Sha1)
- (NSString *)sha1Hash;
@end

@interface NSData (Sha1)
- (NSString *)hexString;
- (NSData *)sha1Hash;
@end
