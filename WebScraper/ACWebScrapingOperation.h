//
//  ACWebScrapingOperation.h
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACWebScraperQueue.h"


/** _ACWebScrapingOperation_ is a _NSOperation_ executing web scraping using an _ACWebScraperQueue_.
 */
@interface ACWebScrapingOperation : NSOperation <ACWebScraperQueueDelegate>

/** @name Properties */

@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isExecuting;

/** An _ACWebScraperQueue_ scraper queue.
 */
@property (nonatomic, strong) ACWebScraperQueue *webScraperQueue;

/** URL to start scraping at.
 */
@property (nonatomic, strong) NSURL *url;

/** An array of libraries to inject in each scraped page; can be javascript code or an URL.
 */
@property (nonatomic, strong) NSArray *libraries;

/** An array of javascripts to evaluate, one at a time.
 */
@property (nonatomic, strong) NSArray *evaluationsQueue;

/** The block to be called when all evaluations have been evaluated, _result_ is the result of the last evaluation.
 */
@property (copy) void(^done)(NSString*result);

/** @name Initialization */

/** Initializer
 * @param url URL to start scraping at
 * @param libraries libraries to inject in each scraped page; can be javascript code or an URL
 * @param evaluations javascripts to evaluate, one at a time
 * @param done the block to be called when all evaluations have been evaluated, _result_ is the result of the last evaluation
 */
- (id)initWithURL:(NSURL*)url
        libraries:(NSArray*)libraries
      evaluations:(NSArray*)evaluations
             done:(void (^)(NSString*result))done;

@end
