//
//  NSString+RNTextStatistics.h
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RNTextStatistics)

- (float)fleschKincaidReadingEase;
- (float)fleschKincaidGradeLevel;
- (float)gunningFogScore;
- (float)colemanLiauIndex;
- (float)smogIndex;
- (float)automatedReadabilityIndex;
- (NSString*)cleanText;
- (NSInteger)letterCount;
- (NSInteger)wordCount;
- (NSInteger)sentenceCount;
- (float)averageWordsPerSentence;
- (NSInteger)syllableCount;
- (NSInteger)wordsWithThreeSyllablesWithProperNouns:(BOOL)countProperNouns;
- (float)percentageWordsWithThreeSyllablesWithProperNouns:(BOOL)countProperNouns;
- (float)averageSyllablesPerWord;
- (NSInteger)totalSyllables;

@end
