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

@protocol ACWebScraperDelegate <NSObject>
@optional
- (void)webScraper:(ACWebScraper*)webScraper isReadyWithState:(ACWebScraperState)state;
- (void)webScraper:(ACWebScraper*)webScraper didEvaluate:(NSString*)evaluation withResult:(NSString*)result;
@end


@interface ACWebScraper : NSObject <UIWebViewDelegate>
@property (nonatomic, weak) id<ACWebScraperDelegate> delegate;
@property (nonatomic, readonly, strong) UIWebView *webview;
@property (nonatomic, readonly, assign) ACWebScraperState state;

- (void)openURL:(NSURL*)url;
- (void)load:(NSString*)evaluation;
- (void)evaluate:(NSString*)evaluation;
- (void)evaluate:(NSString*)evaluation when:(NSString*)when;

@end
