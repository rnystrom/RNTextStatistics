//
//  NSString+RegexReplace.m
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "NSString+RegexReplace.h"

@implementation NSString (RegexReplace)

- (NSString*)stringByReplacingRegularExpression:(NSString*)pattern withString:(NSString*)replace options:(NSRegularExpressionOptions)options {
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:options error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    return [regex stringByReplacingMatchesInString:self options:kNilOptions range:NSMakeRange(0, [self length]) withTemplate:replace];
}

@end
