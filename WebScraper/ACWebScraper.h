//
//  ACWebScraper.h
//  WebScraper
//
//  Created by Arnaud Coomans on 2/23/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIWebView+Document.h"


typedef enum _ACWebScraperState {
    ACWebScraperStateNull = 0,
    ACWebScraperStateWebViewLoaded = 1,
    ACWebScraperStateDOMReady = 2,
    ACWebScraperStateDOMLoaded = 3,
} ACWebScraperState;

@class ACWebScraper;

/** _ACWebScraperDelegate_ is the delegate for _ACWebScraper_.
 */
@protocol ACWebScraperDelegate <NSObject>
@optional
/** _ACWebScraper_ is ready with state. See _ACWebScraper_'s _state_ property for states description.
 */
- (void)webScraper:(ACWebScraper*)webScraper isReadyWithState:(ACWebScraperState)state;

/** _ACWebScraper_ has evaluated the javascript code and return its returned value
 */
- (void)webScraper:(ACWebScraper*)webScraper didEvaluate:(NSString*)evaluation withResult:(NSString*)result;

/** _ACWebScraper_ has not evaluated the javascript code because the _when_ condition was never met.
 */
- (void)webScraper:(ACWebScraper*)webScraper didNotEvaluate:(NSString*)evaluation when:(NSString*)when;

@end



/** _ACWebScraper_ is a web scraper for iOS.
 */
@interface ACWebScraper : NSObject <UIWebViewDelegate>

/** @name Properties */

/** The webscaper delegate.
 */
@property (nonatomic, weak) id<ACWebScraperDelegate> delegate;

/** The UIWebView used for the web scraping.
 */
@property (strong) UIWebView *webview;

/** The number of seconds to wait for when to become true (if when is javascript condition) before failing
 */
@property (nonatomic, assign) NSInteger whenCount;

/** The current state of the webscraper.
 *
 * Can be one of:
 * - _ACWebScraperStateNull_, web page not loaded yet
 * - _ACWebScraperStateWebViewLoaded_, UIWebView is done loading
 * - _ACWebScraperStateDOMReady_, DOM is ready but all content may not yet be loaded
 * - _ACWebScraperStateDOMLoaded_, DOM ready and its content was loaded
 */
@property (nonatomic, readonly, assign) ACWebScraperState state;


/** @name Opening a web page */

/** Open an URL.
 */
- (void)openURL:(NSURL*)url;

/** @name Loading and evaluating code */

/** Load javascript code in the page. Do not return anything.
 * @param evaluation javascript code to evaluate. 
 */
- (void)load:(NSString*)evaluation;

/** Evaluate javascript code. Return value is returned to the _ACWebScraperDelegate_'s _webScraper:didEvaluate:withResult:_ .
 * @param evaluation javascript code to evaluate
 */
- (void)evaluate:(NSString*)evaluation;

/** Evaluate javascript code after some javascript condition is met. Return value is returned to the _ACWebScraperDelegate_'s _webScraper:didEvaluate:withResult:_ .
 * @param evaluation javascript code to evaluate
 * @param when _NSString_ with javascript condition that if returns true, _evaluation_ will be evaluated; or a _NSNumber_ with seconds before _evaluation_ will be evaluated
 */
- (void)evaluate:(NSString*)evaluation when:(id)when;

@end
