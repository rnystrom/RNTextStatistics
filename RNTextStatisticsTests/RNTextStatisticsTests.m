//
//  RNTextStatisticsTests.m
//  RNTextStatisticsTests
//
//  Created by Ryan Nystrom on 11/15/12.
//  Copyright (c) 2012 Ryan Nystrom. All rights reserved.
//

#import "RNTextStatisticsTests.h"
#import "NSString+RNTextStatistics.h"

@implementation RNTextStatisticsTests {

}

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// TODO: Add following tests
// Syllable counting test

- (void)testCleanText {
    NSString *raw = @"Maecenas 1234\n\r sed\ndiam eget\rrisus varius  blandit sit amet non magna.";
    NSString *expected = @"Maecenas sed diam eget risus varius blandit sit amet non magna.";
    NSString *clean = [raw cleanText];
    STAssertTrue([clean isEqualToString:expected], @"Text not cleaned:\n%@",clean);
}

- (void)testSentenceCount {
    NSString *raw = @"Etiam porta sem malesuada magna mollis euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Aenean lacinia bibendum nulla sed consectetur.";
    NSInteger expected = 4;
    NSInteger result = [raw sentenceCount];
    STAssertTrue(expected == result, @"Sentence count should be %i, is %i.",expected,result);
}

- (void)testWordCount {
    NSString *raw = @"Elit 111 Euismod  Lorem Cursus Pharetra";
    NSInteger expected = 5;
    NSInteger result = [raw wordCount];
    STAssertTrue(expected == result, @"Word count should be %i, is %i.",expected,result);
}

- (void)testLetterCount {
    NSString *raw = @"a sdfas dfasdf? 1111 asdfasdf asdf.";
    NSInteger expected = 24;
    NSInteger result = [raw letterCount];
    STAssertTrue(expected == result, @"Letter count is %i, should be %i.",result,expected);
}

- (void)testSyllableCount {
    // test preset words that don't follow rules
    NSArray *setWords = @[@"simile",@"forever"];
    for (NSString *word in setWords) {
        STAssertTrue([word syllableCount] == 3, @"Strict word %@ not returned.");
    }
    STAssertTrue([@"shoreline" syllableCount], @"Syllable not counted properly.");
    
    NSArray *oneSyllables = @[@"dog",@"cat",@"bird"];
    for (NSString *string in oneSyllables) {
        STAssertTrue([string syllableCount] == 1, @"One syllable word %@ incorrect",string);
    }
    
    NSArray *twoSyllables = @[@"kitty",@"doggie",@"happy"];
    for (NSString *string in twoSyllables) {
        STAssertTrue([string syllableCount] == 2, @"Double syllable word %@ incorrect",string);
    }
}

@end
