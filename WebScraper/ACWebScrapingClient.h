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
@interface ACWebScrapingClient : NSObject <ACWebScrapingOperationDelegate>

/** @name Properties */

/** Operation queue
 */
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/** Should share only one webview among all operations. Defaults to NO. If set to yes, maximum concurrent operations
 * will be reduced to 1.
 */
@property (nonatomic, assign) BOOL shouldShareWebView;

/** Stop and skip an operation if one of its when condition fails
 */
@property (nonatomic, assign) BOOL skipIfWhenFails;

/** @name Scraping operations */

/** Start scraping
 * @param url URL to start scraping at
 * @param libraries libraries to inject in each scraped page; can be javascript code or an URL
 * @param evaluations javascripts to evaluate, one at a time
 * @param done the block to be called when all evaluations have been evaluated, _result_ is the result of the last evaluation
 */
- (ACWebScrapingOperation*)scrapURL:(NSURL*)url
                          libraries:(NSArray*)libraries
                        evaluations:(NSArray*)evaluations
                            success:(void (^)(NSString*result))success
                            failure:(void (^)(NSError **error))failure;

@end