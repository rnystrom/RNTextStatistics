RNTextStatistics
===

This project is an Objective-C port of Dave Child's awesome [Text-Statistics](https://github.com/DaveChild/Text-Statistics) project. More information about readability tests can be found [here](http://plainlanguage.com/newreadability.html).

## Installation ##

Simply drag the RNTextStatistics folder into your project. Then import *only* the RNTextStatistics category on NSString into either individual files or your Prefix Header.

``` objective-c
#import "NSString+RNTextStatistics.h"
```

## Usage ##

All readability tests and statistics caluclations are available simple as Categories on NSString which means you can just call them on a string. There is nothing fancy going on here.

``` objective-c
- (float)fleschKincaidReadingEase;
- (float)fleschKincaidGradeLevel;
- (float)gunningFogScore;
- (float)colemanLiauIndex;
- (float)smogIndex;
- (float)automatedReadabilityIndex;
```

##### Example #####

``` objective-c
NSString *raw = @"Quam Nullam Fermentum Cras Ornare";
float fleschEase = [raw fleschKincaidReadingEase];  // 49.48
```

Super simple.

### [Documentation](http://rnystrom.github.com/RNTextStatistics/index.html) ###

## Unit Tests ##

There is a small suite of unit tests included in the example. The tests are not exhaustive, only there to prove that existing functionality is unchanged after updates and pull requests. I will not accept any pull requests without adequate unit tests.

## Contact

* [@nystrorm](https://twitter.com/nystrorm) on Twitter
* [@rnystrom](https://github.com/rnystrom) on Github
* <a href="mailTo:rnystrom@whoisryannystrom.com">rnystrom [at] whoisryannystrom [dot] com</a>

## License

Copyright (c) 2012 Ryan Nystrom (http://whoisryannystrom.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.