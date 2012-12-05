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

#import "RNTextStatisticsTests.h"
#import "NSString+RNTextStatistics.h"

// default 3% standard deviation for readability tests
static float kStddev = 0.03f;

BOOL runTest(float result, float expected, float stddev) {
    float minExpected = expected - expected * stddev;
    float maxExpected = expected + expected * stddev;
    return minExpected <= result && result <= maxExpected;
}

@implementation RNTextStatisticsTests {
    NSString *_longParagraph;
}

- (void)setUp
{
    [super setUp];
    
    _longParagraph = @"Europeans have long regarded kangaroos as strange animals. Early explorers described them as creatures that had heads like deer (without antlers), stood upright like men, and hopped like frogs. Combined with the two-headed appearance of a mother kangaroo, this led many back home to dismiss them as travelers' tales for quite some time. The first kangaroo to be exhibited in the western world was an example shot by John Gore, an officer on Captain Cook's Endeavor in 1770. The animal was shot and its skin and skull transported back to England whereupon it was stuffed (by taxidermists who had never seen the animal before) and displayed to the general public as a curiosity.\nKangaroos have large, powerful hind legs, large feet adapted for leaping, a long muscular tail for balance, and a small head. Like all marsupials, female kangaroos have a pouch called a marsupium in which joeys complete postnatal development.\nKangaroos are the only large animals to use hopping as a means of locomotion. The comfortable hopping speed for Red Kangaroo is about 13–16 mph... This fast and energy-efficient method of travel has evolved because of the need to regularly cover large distances in search of food and water, rather than the need to escape predators.";
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
    NSString *empty = @"";
    NSInteger emptyResult = [empty sentenceCount];
    STAssertTrue(emptyResult == 0, @"Empty string sentence count of %i",emptyResult);
    
    NSString *raw = @"Etiam porta sem malesuada magna mollis euismod. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sed diam eget risus varius blandit sit amet non magna. Aenean lacinia bibendum nulla sed consectetur.";
    NSInteger expected = 4;
    NSInteger result = [raw sentenceCount];
    STAssertTrue(expected == result, @"Sentence count should be %i, is %i.",expected,result);
}

- (void)testWordCount {
    NSString *empty = @"";
    NSInteger emptyResult = [empty wordCount];
    STAssertTrue(emptyResult == 0, @"Empty string word count of %i",emptyResult);
    
    NSString *raw = @"Elit 111 Euismod  Lorem Cursus Pharetra";
    NSInteger expected = 5;
    NSInteger result = [raw wordCount];
    STAssertTrue(expected == result, @"Word count should be %i, is %i.",expected,result);
}

- (void)testLetterCount {
    NSString *empty = @"";
    NSInteger emptyResult = [empty letterCount];
    STAssertTrue(emptyResult == 0, @"Empty string letter count of %i",emptyResult);
    
    NSString *raw = @"a sdfas dfasdf? 1111 asdfasdf asdf.";
    NSInteger expected = 24;
    NSInteger result = [raw letterCount];
    STAssertTrue(expected == result, @"Letter count is %i, should be %i.",result,expected);
}

- (void)testSyllableCount {
    // empty string
    NSString *empty = @"";
    NSInteger result = [empty syllableCount];
    STAssertTrue(result == 0, @"Empty string syllable count of %i",result);
    
    // test preset words that don't follow rules
    NSArray *setWords = @[@"simile",@"forever"];
    for (NSString *word in setWords) {
        STAssertTrue([word syllableCount] == 3, @"Strict word %@ not returned.");
    }
    STAssertTrue([@"shoreline" syllableCount], @"Syllable not counted properly.");
    
    NSArray *oneSyllables = @[@"dog",@"cat",@"bird",@"deal",@"deign"];
    for (NSString *string in oneSyllables) {
        STAssertTrue([string syllableCount] == 1, @"One syllable word %@ incorrect",string);
    }
    
    NSArray *twoSyllables = @[@"kitty",@"doggie",@"happy"];
    for (NSString *string in twoSyllables) {
        STAssertTrue([string syllableCount] == 2, @"Double syllable word %@ incorrect",string);
    }
    
    NSArray *threeSyllables = @[@"poetry",@"delighting",@"falconry"];
    for (NSString *string in threeSyllables) {
        STAssertTrue([string syllableCount] == 3, @"Triple syllable word %@ incorrect",string);
    }
}

- (void)testFleschEase {
    float result = [_longParagraph fleschKincaidReadingEase];
    float expected = 58.3f;
    STAssertTrue(runTest(result, expected, kStddev), @"Flesch Ease; Result: %.3f; Expected: %.3f",result, expected);
}

- (void)testFleschGrade {
    float result = [_longParagraph fleschKincaidGradeLevel];
    float expected = 10.3f;
    STAssertTrue(runTest(result, expected, kStddev), @"Flesch Grade; Result: %.3f; Expected: %.3f",result, expected);
}

- (void)testGunningFog {
    float result = [_longParagraph gunningFogIndex];
    float expected = 14.3f;
    STAssertTrue(runTest(result, expected, kStddev), @"Gunning Fog; Result: %.3f; Expected: %.3f",result, expected);
}

- (void)testColeman {
    float result = [_longParagraph colemanLiauIndex];
    float expected = 12.8f;
    STAssertTrue(runTest(result, expected, kStddev), @"Coleman; Result: %.3f; Expected: %.3f",result, expected);
}

- (void)testSMOG {
    float result = [_longParagraph smogIndex];
    float expected = 10.7f;
    STAssertTrue(runTest(result, expected, kStddev), @"SMOG; Result: %.3f; Expected: %.3f",result, expected);
}

- (void)testARI {
    float result = [_longParagraph automatedReadabilityIndex];
    float expected = 11.8f;
    STAssertTrue(runTest(result, expected, kStddev), @"ARI; Result: %.3f; Expected: %.3f",result, expected);
}

@end
