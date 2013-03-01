//
//  ACWebScrapingClient.h
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACWebScrapingOperation.h"

/** _ACWebScrapingClient_ is a client for web scraping.
 */
@interface ACWebScrapingClient : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

/** @name Scraping operations */

/** Start scraping
 * @param url URL to start scraping at
 * @param libraries libraries to inject in each scraped page; can be javascript code or an URL
 * @param evaluations javascripts to evaluate, one at a time
 * @param done the block to be called when all evaluations have been evaluated, _result_ is the result of the last evaluation
 */
- (ACWebScrapingOperation*)scrapURL:(NSURL*)url
     libraries:(NSMutableArray*)libraries
   evaluations:(NSMutableArray*)evaluations
          done:(void (^)(NSString*result))done;

@end