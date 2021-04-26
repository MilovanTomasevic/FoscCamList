//
//  MTLogger.h
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTLogger : NSObject


/*!
 0 - No messages are shown
 1 - All messages are shown
 2 - Debug and Error messages are shown
 3 - Only Error messages are shown
 */

#if DEBUG
#define DEBUG_LEVEL 1
#else
#define DEBUG_LEVEL 0
#endif

#if DEBUG_LEVEL == 1
#define LogI(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"[I]",args);
#define LogD(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"[D]",args);
#define LogE(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"[E]",args);
#elif DEBUG_LEVEL == 2
#define LogI(args...)
#define LogD(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"[D]",args);
#define LogE(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"[E]",args);
#elif DEBUG_LEVEL == 3
#define LogD(args...)
#define LogI(args...)
#define LogE(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,@"[E]",args);
#elif DEBUG_LEVEL == 0
#define LogD(args...)
#define LogI(args...)
#define LogE(args...)
#endif

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *logLevel ,NSString *format, ...);

@end
