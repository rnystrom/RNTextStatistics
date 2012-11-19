//
//  NSString+RNTextStatistics.h
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RNTextStatistics)

- (NSString*)cleanText;
- (NSInteger)letterCount;
- (NSInteger)wordCount;
- (NSInteger)sentenceCount;
- (CGFloat)averageWordsPerSentence;
- (NSInteger)syllableCount;

@end
