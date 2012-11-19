//
//  NSRegularExpression+SimpleRegex.m
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "NSRegularExpression+SimpleRegex.h"

@implementation NSRegularExpression (SimpleRegex)

+ (NSRegularExpression*)simpleRegex:(NSString*)pattern {
    return [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
}

+ (NSString*)stringByReplacingOccurenceOfPatterns:(NSArray *)patterns inString:(NSString *)string options:(NSRegularExpressionOptions)options withTemplate:(NSString *)templ count:(NSInteger *)count {
    __block NSInteger matchCount = 0;
    __block NSString *strippedString = [string copy];
    
    [patterns enumerateObjectsUsingBlock:^(NSString *pattern, NSUInteger idx, BOOL *stop) {
        NSRegularExpression *regex = [NSRegularExpression simpleRegex:pattern];
        matchCount = [regex numberOfMatchesInString:string options:kNilOptions range:NSMakeRange(0, [string length])];
        strippedString = [regex stringByReplacingMatchesInString:strippedString options:kNilOptions range:NSMakeRange(0, [strippedString length]) withTemplate:@""];
    }];
    
    *count = matchCount;
    return strippedString;
}

@end
