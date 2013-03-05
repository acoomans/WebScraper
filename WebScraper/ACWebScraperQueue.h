//
//  ACWebScraperQueue.h
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/25/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACWebScraper.h"

@class ACWebScraperQueue;

/** _ACWebScraperQueueDelegate_ is the delegate for _ACWebScraperQueue_.
 */
@protocol ACWebScraperQueueDelegate <NSObject>
@optional
/** _ACWebScraperQueue_ has evaluated all javascript codes in the queue and returns the return value of the last evaluation.
 */
- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didEvaluateQueueWithResult:(NSString*)result;

/** _ACWebScraperQueue_ has not evaluated the javascript code because the _when_ condition was never met.
 */
- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didNotEvaluate:(NSString*)evaluation when:(NSString*)when;
@end



/** _ACWebScraperQueue_ is a queue for the _ACWebScraper_ web scraper.
 */
@interface ACWebScraperQueue : NSObject <ACWebScraperDelegate>

/** @name Properties */

/** The webscaper queue delegate.
 */
@property (nonatomic, weak) id<ACWebScraperQueueDelegate> delegate;

/** Queue containing all items remaining to be evaluated.
 * An item can be:
 * - a _NSString_ to be evaluated
 * - a _NSArray_ containing _evaluation_ and _when_ at position 0 and 1 respectively
 * - a _NSDictionary_ containing _evaluation_ and _when_ with keys @"evaluation" and @"when" respectively
 *
 * _evaluation_ is the javascript code to be evaluated.
 * _when_ is a javascript condition or number of seconds.
 * See _ACWebScraper_'s _evaluate:when:_.
 */
@property (nonatomic, strong) NSMutableArray *evaluationsQueue;

/** Stop processing further evaluations if a when condition is never met. Defaults to NO.
 */
@property (nonatomic, assign) BOOL stopIfWhenFails;

/** Libraries to be planted in the scraper
 * Can be either:
 * - a _NSString_ containing javascript to be loaded
 * - a _NSString_ beginning with _http_ and pointing to an only javascript resource
 */
@property (nonatomic, strong) NSMutableArray *libraries;

/** The _ACWebScraper_ webscraper.
 */
@property (nonatomic, strong) ACWebScraper *webScraper;

/** @name Start scraping */
 
/** Start Scraping from empty page
 */
- (void)startScraping;

/** Start Scraping from page at given URL
 * @param url URL to start scraping at
 */
- (void)startScrapingAtURL:(NSURL*)url;

@end
