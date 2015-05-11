//
//  main.m
//  Word2vec
//
//  Created by Gianluca Bertani on 04/05/15.
//  Copyright (c) 2015 Gianluca Bertani. All rights reserved.
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
#import <MAChineLearning/MAChineLearning.h>

#import "LineReader.h"

#define VECTOR_SZIE                      (300)
#define TRAINING_ITERATIONS                (5)
#define SKIP_GRAM_WINDOW                   (6)
#define WORD_MIN_COUNT                     (5)
#define LEARNING_RATE                      (0.025)

#define MISSING_ARGUMENT                   (9)
#define OK                                 (0)


/**
 * This utility reads *.txt files from a path, specified as the only argument,
 * and builds a dictionary of words using a simplified Word2vec algorithm,
 * designed to be simple to understand rather than to be fast. Parameters may
 * be set with constants here above, but most of the times the defaults 
 * will be ok.
 *
 * Files are read line by line, considering each line a different text. 
 * Numbers are skipped.
 */
int main(int argc, const char * argv[]) {
	@autoreleasepool {
		if (argc != 2)
			return MISSING_ARGUMENT;
		
		// Get directory list at path of first argument
		NSFileManager *manager= [NSFileManager defaultManager];
		NSString *path= [[NSString alloc] initWithCString:argv[1] encoding:NSUTF8StringEncoding];
		NSArray *fileNames= [manager contentsOfDirectoryAtPath:path error:nil];
		
		// Prepare the dictionary
		TokenDictionary *dictionary= [TokenDictionary dictionaryWithMaxSize:300000];
		
		// First loop on all the files to determine the dictionary
		for (NSString *fileName in fileNames) {
			NSString *filePath= [path stringByAppendingPathComponent:fileName];
			
			// Skip non-txt files
			if (![fileName hasSuffix:@".txt"])
				continue;
			
			NSLog(@"Now reading file: %@", fileName);

			LineReader *reader= [[LineReader alloc] initWithFileHandle:filePath];

			do {
				NSString *line= [reader readLine];
				if (!line)
					break;
				
				// Build the dictionary with the current line
				[BagOfWords buildDictionaryWithText:line
											 textID:nil
										 dictionary:dictionary
										   language:nil
									  wordExtractor:WordExtractorTypeSimpleTokenizer
								   extractorOptions:WordExtractorOptionOmitNumbers];
				
				if (reader.lineNumber % 1000 == 0)
					NSLog(@"- line: %6lu", reader.lineNumber);

			} while (YES);
			
			[reader close];
		}
		
		NSLog(@"Pre-filtering size:     %8lu", dictionary.size);
		
		// Filter dictionary for rare words
		[dictionary discardTokensWithOccurrenciesLessThan:WORD_MIN_COUNT];
		[dictionary compact];
		
		NSLog(@"Final dictionary size:  %8lu", dictionary.size);
		NSLog(@"Total number of tokens: %8lu", dictionary.totalTokens);
		
		// Prepare the neural network:
		// - input and output sizes are set to the dictionary (bag of words) size
		// - hidden size is set to the desired vector size
		// - activation function is logistic
		NeuralNetwork *net= [[NeuralNetwork alloc] initWithLayerSizes:@[[NSNumber numberWithInt:(int) dictionary.size],
																		@VECTOR_SZIE,
																		[NSNumber numberWithInt:(int) dictionary.size]]
												   outputFunctionType:ActivationFunctionTypeLogistic];

		// Loop for the training iterations
		for (int iter= 0; iter < TRAINING_ITERATIONS; iter++) {
		
			// Loop all the files
			for (NSString *fileName in fileNames) {
				NSString *filePath= [path stringByAppendingPathComponent:fileName];

				// Skip non-txt files
				if (![fileName hasSuffix:@".txt"])
					continue;
				
				LineReader *reader= [[LineReader alloc] initWithFileHandle:filePath];
				
				NSLog(@"Iteration %2d, now training with file: %@", iter, fileName);

				do {
					NSString *line= [reader readLine];
					if (!line)
						break;
					
					// !! TO DO: to be completed
					
					if (reader.lineNumber % 1000 == 0)
						NSLog(@"- line: %6lu", reader.lineNumber);
				
				} while (YES);
				
				[reader close];
			}
		}
	}
	
    return 0;
}