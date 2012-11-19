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

/** Quickly get readability and text statistics from NSStrings. */
@interface NSString (RNTextStatistics)

///---------------------------------------------------------------------------------------
/// @name Readability Tests
///---------------------------------------------------------------------------------------

/** Get the Flesch Kincaid Reading Ease for a string of text.
 
 @see [Flesch Kincaid Reading Ease](http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_test)
 */
- (float)fleschKincaidReadingEase;

/** Get the Flesch Kincaid Grade Level for a string of text.
 
 @see [Flesch Kincaid Grade Level](http://en.wikipedia.org/wiki/Flesch–Kincaid_readability_test)
 */
- (float)fleschKincaidGradeLevel;

/** Get the Gunning Fog Index for a string of text.
 
 @see [Gunning Fog Index](http://en.wikipedia.org/wiki/Gunning_fog_index)
 */
- (float)gunningFogIndex;

/** Get the Coleman Liau Index for a string of text.
 
 @see [Coleman Liau Index](http://en.wikipedia.org/wiki/Coleman–Liau_index)
 */
- (float)colemanLiauIndex;

/** Get the SMOG Index for a string of text.
 
 @see [SMOG Index](http://en.wikipedia.org/wiki/SMOG)
 */
- (float)smogIndex;

/** Get the Automated Readability Index for a string of text.
 
 @see [Automated Readability Index](http://en.wikipedia.org/wiki/Automated_Readability_Index)
 */
- (float)automatedReadabilityIndex;

///---------------------------------------------------------------------------------------
/// @name Counting
///---------------------------------------------------------------------------------------

/** Get the total number of alphabetical characters in a string. */
- (NSInteger)letterCount;

/** Get the total number of words in a string. */
- (NSInteger)wordCount;

/** Get the total number of sentences in a string. */
- (NSInteger)sentenceCount;

/** Get the total number of syllables in a word string. 
 
 @see syllableTotal
 */
- (NSInteger)syllableCount;

/** Get the total number of syllables in a string. 
 
 @see syllableCount
 */
- (NSInteger)syllableTotal;

/** Get the total number of words with at least 3 syllables in a string. 
 
 @param countProperNouns Decide if proper nouns should be counted as words
 @see percentageWordsWithThreeSyllablesWithProperNouns:
 */
- (NSInteger)wordsWithThreeSyllablesWithProperNouns:(BOOL)countProperNouns;

///---------------------------------------------------------------------------------------
/// @name Averages
///---------------------------------------------------------------------------------------

/** Get the percentage of words with at least 3 syllables in a string. 
 
 @param countProperNouns Decide if proper nouns should be counted as words
 @see wordsWithThreeSyllablesWithProperNouns:
 Returned value is between 0 and 1.
 */
- (float)percentageWordsWithThreeSyllablesWithProperNouns:(BOOL)countProperNouns;

/** Get the average number of syllables per word in a string. */
- (float)averageSyllablesPerWord;

/** Get the average number of words per sentence in a string */
- (float)averageWordsPerSentence;

///---------------------------------------------------------------------------------------
/// @name Utilities
///---------------------------------------------------------------------------------------

/** Clean the text of non-alphanumeric characters, clean terminators, and remove newlines. 
 
 This method is strictly for prepping text to be measured. This should not be used outside of testing.
 */
- (NSString*)cleanText;

@end
