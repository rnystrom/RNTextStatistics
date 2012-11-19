//
//  NSRegularExpression+SimpleRegex.h
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRegularExpression (SimpleRegex)

+ (NSRegularExpression*)simpleRegex:(NSString*)pattern;
+ (NSString*)stringByReplacingOccurenceOfPatterns:(NSArray*)patterns inString:(NSString*)string options:(NSRegularExpressionOptions)options withTemplate:(NSString*)templ count:(NSInteger*)count;

@end
