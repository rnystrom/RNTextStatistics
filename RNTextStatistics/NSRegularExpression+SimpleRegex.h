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

#import <Foundation/Foundation.h>

/** Quick and simplified access to common regular expression and string manipulation functions. */
@interface NSRegularExpression (SimpleRegex)

/** Build a regular expression object.
 
 @param pattern A regular expression.
 @see [NSRegularExpression](https://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html)
 */
+ (NSRegularExpression*)simpleRegex:(NSString*)pattern;

/** Replace all occurences of a pattern with a template.
 
    NSInteger *count;
    ...
    [NSRegularExpression stringByReplacingOccurenceOfPatterns:patterns inString:string options:options withTemplate:templ count:&count];
    NSLog(@"%li",count);    // will return the number of matches that were replaced
 
 @param patterns A regular expression.
 @param string A string to search and operate on.
 @param options Regular expression options.
 @param templ A template to replace all matches of the regular expression.
 @param count A pointer count to get the total number of matches that were replaced.
 @see @see [NSRegularExpression](https://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSRegularExpression_Class/Reference/Reference.html)
 */
+ (NSString*)stringByReplacingOccurenceOfPatterns:(NSArray*)patterns inString:(NSString*)string options:(NSRegularExpressionOptions)options withTemplate:(NSString*)templ count:(NSInteger*)count;

@end
