//
//  MLWordDictionary.h
//  MAChineLearning
//
//  Created by Gianluca Bertani on 10/05/15.
//  Copyright (c) 2015-2017 Gianluca Bertani. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  * Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  * Neither the name of Gianluca Bertani nor the names of its contributors
//    may be used to endorse or promote products derived from this software
//    without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>

#import "MLReal.h"


@class MLWordInfo;

typedef NS_ENUM(NSUInteger, MLWordFilterOutcome) {
	MLWordFilterOutcomeDiscardWord= 0,
	MLWordFilterOutcomeKeepWord= 1
};

typedef MLWordFilterOutcome (^MLWordFilter)(MLWordInfo *wordInfo);


@interface MLWordDictionary : NSObject {
	
@protected
	NSMutableDictionary *_dictionary;
	
	NSUInteger _totalWords;
	NSUInteger _totalDocuments;
	
	NSMutableSet *_documentIDs;
	
	MLReal *_idfWeights;
	BOOL _idfWeightsDirty;
}


#pragma mark -
#pragma mark Initialization

- (instancetype) initWithDictionary:(MLWordDictionary *)dictionary;
- (instancetype) initWithWordInfos:(NSArray *)wordInfos;


#pragma mark -
#pragma mark Dictionary access

- (BOOL) containsWord:(NSString *)word;
- (MLWordInfo *) infoForWord:(NSString *)word;


#pragma mark -
#pragma mark Dictionary filtering

- (MLWordDictionary *) keepWordsWithHighestOccurrenciesUpToSize:(NSUInteger)size;

- (MLWordDictionary *) discardWordsWithOccurrenciesLessThan:(NSUInteger)minOccurrencies;
- (MLWordDictionary *) discardWordsWithOccurrenciesGreaterThan:(NSUInteger)maxOccurrencies;

- (MLWordDictionary *) filterWordsWith:(MLWordFilter)filter;


#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) NSUInteger size;

@property (nonatomic, readonly) NSArray *wordInfos;

@property (nonatomic, readonly) NSUInteger totalWords;
@property (nonatomic, readonly) NSUInteger totalDocuments;

@property (nonatomic, readonly) NSSet *documentIDs;

@property (nonatomic, readonly) MLReal *idfWeights;


@end
