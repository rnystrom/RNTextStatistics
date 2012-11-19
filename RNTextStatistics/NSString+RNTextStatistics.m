//
//  NSString+RNTextStatistics.m
//  RNTextStatistics
//
//  Created by Ryan Nystrom on 11/18/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "NSString+RNTextStatistics.h"
#import "NSRegularExpression+SimpleRegex.h"
#import "NSString+RegexReplace.h"

@implementation NSString (RNTextStatistics)

- (NSString*)cleanText {
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
    text = [[NSRegularExpression simpleRegex:@"([\\.])[\\. ]+"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@"."];
    // Pad sentence terminators
    text = [[NSRegularExpression simpleRegex:@"[ ]*([\\.])"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@"."];
    // Remove "words" comprised only of numbers
    text = [[NSRegularExpression simpleRegex:@"\\s[0-9]+\\s"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    // Remove multiple spaces
    text = [[NSRegularExpression simpleRegex:@"\\s+$"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    text = [[NSRegularExpression simpleRegex:@"\\s+"] stringByReplacingMatchesInString:text options:kNilOptions range:NSMakeRange(0, [text length]) withTemplate:@" "];
    return text;
}

#pragma mark - Counting

- (NSInteger)letterCount {
    NSString *cleanText = [self cleanText];
    NSString *strippedString = [cleanText stringByReplacingRegularExpression:@"[^a-zA-Z]+" withString:@"" options:NSRegularExpressionCaseInsensitive];
    NSInteger letterCount = [strippedString length];
    return letterCount;
}

- (NSInteger)wordCount {
    NSString *cleanText = [self cleanText];
    NSString *strippedText = [cleanText stringByReplacingRegularExpression:@"[^\\s]" withString:@"" options:kNilOptions];
    NSInteger wordCount = 1 + [strippedText length];
    return wordCount;
}

- (NSInteger)sentenceCount {
    NSString *cleanText = [self cleanText];
    NSString *strippedString = [cleanText stringByReplacingRegularExpression:@"[^\\.\\!\\?]+" withString:@"" options:NSRegularExpressionCaseInsensitive];
    NSInteger sentencesCount = MAX(1, [strippedString length]);
    return sentencesCount;
}

// No test required. sentenceCount and wordCount are already tested
- (CGFloat)averageWordsPerSentence {
    NSString *cleanText = [self cleanText];
    NSInteger sentenceCount = [cleanText sentenceCount];
    NSInteger wordCount = [cleanText wordCount];
    return (CGFloat)wordCount / (CGFloat)sentenceCount;
}

#pragma mark - Syllables

- (NSInteger)syllableCount {
    // remove non-alpha chars
    NSString *strippedString = [self stringByReplacingRegularExpression:@"[^A-Za-z]" withString:@"" options:kNilOptions];
    // use lowercase for brevity w/ options + patterns
    NSString *lowercase = [strippedString lowercaseString];
    
    // altered in enumerate blocks
    __block NSInteger syllableCount = 0;
    
    // special rules that don't follow syllable matching patterns
    NSDictionary *exceptions = @{
    @"simile" : @3,
    @"forever" : @3,
    @"shoreline" : @2,
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
    //"^[dr]e[aeiou][^aeiou]+$" // Sorts out deal deign etc
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
    
    return syllableCount;
}


@end
