//
//  NSString+RegexReplace.h
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/16/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexReplace)

- (NSString*)stringByReplacingRegularExpression:(NSString*)pattern withString:(NSString*)replace options:(NSRegularExpressionOptions)options;

@end
