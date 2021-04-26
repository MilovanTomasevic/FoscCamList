//
//  MTLogger.m
//  MTcams
//
//  Created by Milovan Tomasevic on 05/10/2017.
//  Copyright © 2017 administrator. All rights reserved.
//

#import "MTLogger.h"
#import <sys/time.h>

@implementation MTLogger


char            fmt[48], buf[64];
struct timeval  tv;
struct tm       *tm;

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *logLevel ,NSString *format, ...){
    // Type to hold information about variable arguments.
    va_list ap;
    
    // Initialize a variable argument list.
    va_start (ap, format);
    
    // NSLog only adds a newline to the end of the NSLog format if
    // one is not already there.
    // Here we are utilizing this feature of NSLog()
    if (![format hasSuffix: @"\n"])
    {
        format = [format stringByAppendingString: @"\n"];
    }
    
    NSString *body = [[NSString alloc] initWithFormat:format arguments:ap];
    
    // End using variable argument list.
    va_end (ap);
    
    NSString *fileName = [[NSString stringWithUTF8String:file] lastPathComponent];
    
    gettimeofday(&tv, NULL);
    if((tm = localtime(&tv.tv_sec)) != NULL){
        strftime(fmt, sizeof fmt, "%Y-%m-%d %H:%M:%S", tm);
        snprintf(buf, sizeof buf, "%s.%03d", fmt, (tv.tv_usec/1000));
    }
    
#if DEBUG_LEVEL != 0
    fprintf(stderr, "%s%s(%s Line: %d) %s", buf,[logLevel UTF8String], [fileName UTF8String], lineNumber, [body UTF8String]);
#endif
}

@end
