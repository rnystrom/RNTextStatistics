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

#import "NSString+RNTextStatistics.h"
#import "NSRegularExpression+SimpleRegex.h"
#import "NSString+RegexReplace.h"
#import <objc/runtime.h>

static void * const kCleanString = (void*)&kCleanString;
static void * const kLetterCount = (void*)&kLetterCount;
static void * const kWordCount = (void*)&kWordCount;
static void * const kSentenceCount = (void*)&kSentenceCount;
static void * const kSyllablesPerWord = (void*)&kSyllablesPerWord;

@implementation NSString (RNTextStatistics)

#pragma mark - Specific Tests

- (float)fleschKincaidReadingEase {
    return 206.835f - 1.015f * [self averageWordsPerSentence] - 84.6f * [self averageSyllablesPerWord];
}

- (float)fleschKincaidGradeLevel {
    return 0.39f * [self averageWordsPerSentence] + 11.8f * [self averageSyllablesPerWord] - 15.59f;
}

- (float)gunningFogIndex {
    return ([self averageWordsPerSentence] + [self percentageWordsWithThreeSyllablesWithProperNouns:YES] * 100.f) * 0.4f;
}

- (float)colemanLiauIndex {
    return 5.89f * ([self letterCount] / (float)[self wordCount]) - 0.3f * ([self sentenceCount] / (float)[self wordCount]) - 15.8f;
}

- (float)smogIndex {
    return 1.043f * sqrtf([self wordsWithThreeSyllablesWithProperNouns:YES] * (30.f / (float)[self sentenceCount]) + 3.1291f);
}

- (float)automatedReadabilityIndex {
    return 4.71f * ([self letterCount] / (float)[self wordCount]) + 0.5f * ([self wordCount] / (float)[self sentenceCount]) - 21.43f;
}

#pragma mark - Formatting

- (NSString*)cleanText {
    NSString *cleanString = objc_getAssociatedObject(self, kCleanString);
    if (cleanString) return cleanString;
    
    NSString *text = [self copy];
    // Strip tags
    text = [[NSRegularExpression simpleRegex:@"<[^>]+>"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@""];
    // Replace commas, hyphens, quotes etc (count them as spaces)
    text = [[NSRegularExpression simpleRegex:@"[,:;\\(\\)\\-]"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@""];
    // Unify terminators
    text = [[NSRegularExpression simpleRegex:@"[\\.\\!\\?]"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@"."];
    // trim whitespace
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // add ending terminator if it's not there
    text = [text stringByAppendingString:@"."];
    // Replace new lines with spaces
    text = [[NSRegularExpression simpleRegex:@"[ ]*(\\n|\\r\\n|\\r)[ ]*"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    // Check for duplicated terminators
    text = [[NSRegularExpression simpleRegex:@"\\.[\\.]+"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@"."];
    // Pad sentence terminators
    text = [[NSRegularExpression simpleRegex:@"[ ]*([\\.])\\s"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@". "];
    // Remove "words" comprised only of numbers
    text = [[NSRegularExpression simpleRegex:@"\\s[0-9]+\\s"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    // Remove multiple spaces
    text = [[NSRegularExpression simpleRegex:@"\\s+$"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    text = [[NSRegularExpression simpleRegex:@"\\s+"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    
    objc_setAssociatedObject(self, kCleanString, text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return text;
}

#pragma mark - Counting

- (NSInteger)letterCount {
    NSNumber *number = objc_getAssociatedObject(self, kLetterCount);
    if (number) return [number integerValue];
    
    if ([self isEqualToString:@""]) {
        return 0;
    }
    
    NSString *cleanText = [self cleanText];
    NSString *strippedString = [cleanText stringByReplacingRegularExpression:@"[^a-zA-Z]+" withString:@"" options:NSRegularExpressionCaseInsensitive];
    NSInteger letterCount = [strippedString length];
    
    objc_setAssociatedObject(self, kLetterCount, @(letterCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return letterCount;
}

- (NSInteger)wordCount {
    NSNumber *number = objc_getAssociatedObject(self, kWordCount);
    if (number) return [number integerValue];

    if ([self isEqualToString:@""]) {
        return 0;
    }
    
    NSString *cleanText = [self cleanText];
    NSString *strippedText = [cleanText stringByReplacingRegularExpression:@"[^\\s]" withString:@"" options:kNilOptions];
    NSInteger wordCount = 1 + [strippedText length];
    
    objc_setAssociatedObject(self, kWordCount, @(wordCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return wordCount;
}

- (NSInteger)sentenceCount {
    NSNumber *number = objc_getAssociatedObject(self, kSentenceCount);
    if (number) return [number integerValue];

    if ([self isEqualToString:@""]) {
        return 0;
    }
    
    NSString *cleanText = [self cleanText];
    NSString *strippedString = [cleanText stringByReplacingRegularExpression:@"[^\\.\\!\\?]+" withString:@"" options:NSRegularExpressionCaseInsensitive];
    NSInteger sentencesCount = MAX(1, [strippedString length]);
    
    objc_setAssociatedObject(self, kSentenceCount, @(sentencesCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return sentencesCount;
}

// No test required. sentenceCount and wordCount are already tested
- (float)averageWordsPerSentence {
    NSInteger sentenceCount = [self sentenceCount];
    NSInteger wordCount = [self wordCount];
    return (float)wordCount / (float)sentenceCount;
}

- (NSInteger)wordsWithThreeSyllablesWithProperNouns:(BOOL)countProperNouns {
    NSString *cleanText = [self cleanText];
    __block NSInteger longWordCount = 0;
    NSArray *words = [cleanText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [words enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL *stop) {
        if ([word syllableCount] > 2) {
            if (countProperNouns) {
                longWordCount++;
            }
            else {
                // check for uppercase string (assuming proper noun)
                NSString *firstLetter = [word substringToIndex:1];
                if (! [firstLetter isEqualToString:[firstLetter uppercaseString]]) {
                    longWordCount++;
                }
            }
        }
    }];
    return longWordCount;
}

- (float)percentageWordsWithThreeSyllablesWithProperNouns:(BOOL)countProperNouns {
    NSInteger wordCount = [self wordCount];
    NSInteger longWordCount = [self wordsWithThreeSyllablesWithProperNouns:countProperNouns];
    return (float)longWordCount / (float)wordCount;
}

- (float)averageSyllablesPerWord {
    NSNumber *number = objc_getAssociatedObject(self, kSyllablesPerWord);
    if (number) return [number floatValue];
    
    NSString *cleanText = [self cleanText];
    __block NSInteger syllableCount = 0;
    NSInteger wordCount = [cleanText wordCount];
    NSArray *words = [cleanText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [words enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL *stop) {
        syllableCount += [word syllableCount];
    }];
    
    float syllablesPerWord = (float)syllableCount / (float)wordCount;
    
    objc_setAssociatedObject(self, kSyllablesPerWord, @(syllablesPerWord), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return syllablesPerWord;
}

- (NSInteger)syllableTotal {
    NSString *cleanText = [self cleanText];
    __block NSInteger syllableCount = 0;
    NSArray *words = [cleanText componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [words enumerateObjectsUsingBlock:^(NSString *word, NSUInteger idx, BOOL *stop) {
        syllableCount += [word syllableCount];
    }];
    return syllableCount;
}

- (NSInteger)syllableCount {
    if ([self isEqualToString:@""]) {
        return 0;
    }
    
    NSCache *saved = [NSString syllableCache];
    NSNumber *number = [saved objectForKey:self];
    if (number) return [number integerValue];
    
    // remove non-alpha chars
    NSString *strippedString = [self stringByReplacingRegularExpression:@"[^A-Za-z]" withString:@"" options:kNilOptions];
    // use lowercase for brevity w/ options + patterns
    NSString *lowercase = [strippedString lowercaseString];
    
    // altered in enumerate blocks
    __block NSInteger syllableCount = 0;
    
    // special rules that don't follow syllable matching patterns
    NSDictionary *exceptions = @{
    @"you" : @1,
    @"simile" : @3,
    @"forever" : @3,
    @"shoreline" : @2,
    @"poetry" : @3,
    @"wandered" : @2
    };
    // if one of the preceding words, return special case value
    NSNumber *caught = exceptions[self];
    if (caught) {
        return caught.integerValue;
    }
    
    // These syllables would be counted as two but should be one
    NSArray *subSyllables = @[
    @"cial",
    @"tia",
    @"cius",
    @"cious",
    @"giu",
    @"ion",
    @"iou",
    @"sia$",
    @"[^aeiuoyt]{2}ed$",
    @".ely$",
    @"[cg]h?e[rsd]?$",
    @"rved?$",
    @"[aeiouy][dt]es?$",
    @"[aeiouy][^aeiouydt]e[rsd]?$",
//    @"^[dr]e[aeiou][^aeiou]+$", // Sorts out deal deign etc
    @"[aeiouy]rse$",
    ];
    
    // These syllables would be counted as one but should be two
    NSArray *addSyllables = @[
    @"ia",
    @"riet",
    @"dien",
    @"iu",
    @"io",
    @"ii",
    @"[aeiouym]bl$",
    @"[aeiou]{3}",
    @"^mc",
    @"ism$",
    @"([^aeiouy])\1l$",
    @"[^l]lien",
    @"^coa[dglx].",
    @"[^gq]ua[^auieo]",
    @"dnt$",
    @"uity$",
    @"ie(r|st)$"
    ];
    
    // Single syllable prefixes and suffixes
    NSArray *prefixSuffix = @[
    @"^un",
    @"^fore",
    @"ly$",
    @"less$",
    @"ful$",
    @"ers?$",
    @"ings?$",
    ];
    
    // remove prefix & suffix, count how many are removed
    NSInteger prefixesSuffixesCount = 0;
    NSString *strippedPrefixesSuffixes = [NSRegularExpression stringByReplacingOccurenceOfPatterns:prefixSuffix inString:lowercase options:kNilOptions withTemplate:@"" count:&prefixesSuffixesCount];
    
    // removed non-word chars from word
    NSString *strippedNonWord = [strippedPrefixesSuffixes stringByReplacingRegularExpression:@"[^a-z]" withString:@"" options:kNilOptions];
    NSString *nonVowelPattern = @"[aeiouy]+";
    NSError *vowelError = nil;
    NSRegularExpression *nonVowelRegex = [[NSRegularExpression alloc] initWithPattern:nonVowelPattern options:kNilOptions error:&vowelError];
    NSArray *wordPartsResults = [nonVowelRegex matchesInString:strippedNonWord options:kNilOptions range:NSMakeRange(0, [strippedNonWord length])];
    
    NSMutableArray *wordParts = [NSMutableArray array];
    [wordPartsResults enumerateObjectsUsingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
        NSString *substr = [strippedNonWord substringWithRange:match.range];
        if (substr) {
            [wordParts addObject:substr];
        }
    }];
    
    __block NSInteger wordPartCount = 0;
    [wordParts enumerateObjectsUsingBlock:^(NSString *part, NSUInteger idx, BOOL *stop) {
        if (! [part isEqualToString:@""]) {
            wordPartCount++;
        }
    }];
    
    syllableCount = wordPartCount + prefixesSuffixesCount;
    
    // Some syllables do not follow normal rules - check for them
    // Thanks to Joe Kovar for correcting a bug in the following lines
    [subSyllables enumerateObjectsUsingBlock:^(NSString *subSyllable, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:subSyllable options:kNilOptions error:&error];
        syllableCount -= [regex numberOfMatchesInString:strippedNonWord options:kNilOptions range:NSMakeRange(0, [strippedNonWord length])];
    }];
    
    [addSyllables enumerateObjectsUsingBlock:^(NSString *addSyllable, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:addSyllable options:kNilOptions error:&error];
        syllableCount += [regex numberOfMatchesInString:strippedNonWord options:kNilOptions range:NSMakeRange(0, [strippedNonWord length])];
    }];
    
    syllableCount = syllableCount <= 0 ? 1 : syllableCount;
    
    [saved setObject:@(syllableCount) forKey:self];
    
    return syllableCount;
}

+ (NSCache*)syllableCache {
    static dispatch_once_t pred;
    static NSCache *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[NSCache alloc] init];
    });
    return shared;
}

@end
