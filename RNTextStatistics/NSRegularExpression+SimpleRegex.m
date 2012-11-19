/*
 * RNTextStatistics
 *
 * Created by Ryan Nystrom on 10/2/12.
 * Copyright (c) 2012 Ryan Nystrom. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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
