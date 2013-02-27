//
//  ACWebScraper.m
//  WebScraper
//
//  Created by Arnaud Coomans on 2/23/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACWebScraper.h"
#import "NSString+Javascript.h"

NSString* const ACEvaluateDomReadyScript = @"if (/loaded|complete/.test(document.readyState)) {document.UIWebViewIsDomReady = true;} else {document.addEventListener('DOMContentLoaded', function(){document.UIWebViewIsDomReady = true;}, false);}";
NSString* const ACEvaluateDomLoadedScript  = @"if (/loaded|complete/.test(document.readyState)){document.UIWebViewIsDomLoaded = true;} else {window.addEventListener('load',               function(){document.UIWebViewIsDomLoaded = true;}, false);}";

NSInteger const kACWebScraperWhenCountMax = 5;

@interface ACWebScraper ()
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) ACWebScraperState state;
@property (nonatomic, assign) NSInteger whenCount;
- (void)evaluateWhen:(NSDictionary*)e;
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)evaluation;
@end

@implementation ACWebScraper

- (id)init {
    self = [super init];
    if (self) {
        if ([NSThread isMainThread]) {
            self.webview = [[UIWebView alloc] init];
            self.webview.delegate = self;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.webview = [[UIWebView alloc] init];
                self.webview.delegate = self;
            });
        }
        self.state = ACWebScraperStateNull;
    }
    return self;
}


#pragma mark - 

- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)evaluation {
    NSLog(@"WebScraper: stringByEvaluatingJavaScriptFromString");
    __block NSString *result = nil;
    if ([NSThread isMainThread]) {
        result = [self.webview stringByEvaluatingJavaScriptFromString:evaluation];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            result = [self.webview stringByEvaluatingJavaScriptFromString:evaluation];
        });
    }
    return result;
}

- (void)openURL:(NSURL*)url {
    self.state = ACWebScraperStateNull;
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)load:(NSString*)evaluation {
    if (!evaluation) return;
    [self stringByEvaluatingJavaScriptFromString:evaluation];
}

- (void)evaluate:(NSString*)evaluation {
    NSLog(@"WebScraper: evaluating");
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:evaluation];
    if ([self.delegate respondsToSelector:@selector(webScraper:didEvaluate:withResult:)]) {
        [self.delegate webScraper:self didEvaluate:evaluation withResult:result];
    }
}

- (void)evaluate:(NSString*)evaluation when:(NSString*)when {
    self.whenCount = 0;
    if (!when) {
        [self evaluate:evaluation];
    } else {
        [self evaluateWhen:@{@"evaluation":evaluation, @"when":when}];
    }
}

- (void)evaluateWhen:(NSDictionary*)e { // wrapper for performSelector
    NSString *evaluation = e[@"evaluation"];
    NSString *when = e[@"when"];
    
    NSString *whenResult = [self stringByEvaluatingJavaScriptFromString:[when wrapInFunction]];
    
    if ([@"true" caseInsensitiveCompare:whenResult] == NSOrderedSame) {
        [self evaluate:evaluation];
    } else {
        if (self.whenCount < kACWebScraperWhenCountMax) {
            NSLog(@"WebScraper: waiting to evaluate...");
            self.whenCount++;
            [self performSelector:@selector(evaluateWhen:) withObject:e afterDelay:1];
        } else {
            NSLog(@"WebScraper: waited for too long, stopped. ");
        }
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self documentReadyWithState:ACWebScraperStateWebViewLoaded];
    
    [self stringByEvaluatingJavaScriptFromString:ACEvaluateDomReadyScript];
    [self stringByEvaluatingJavaScriptFromString:ACEvaluateDomLoadedScript];
    [self pollState];
}

#pragma mark - document state

- (void)pollState {
    if ([@"true" caseInsensitiveCompare:[self stringByEvaluatingJavaScriptFromString:@"document.UIWebViewIsDomReady"]] == NSOrderedSame) {
        [self documentReadyWithState:ACWebScraperStateDOMReady];
    }
    
    if ([@"true" caseInsensitiveCompare:[self stringByEvaluatingJavaScriptFromString:@"document.UIWebViewIsDomLoaded"]] == NSOrderedSame) {
        [self documentReadyWithState:ACWebScraperStateDOMLoaded];
    }
    
    if (self.state < ACWebScraperStateDOMLoaded) {
        [self performSelector:@selector(pollState) withObject:nil afterDelay:1];
    }
}

- (void)documentReadyWithState:(ACWebScraperState)state {
    if (self.state < state) {
        self.state = state;
    }
    if ([self.delegate respondsToSelector:@selector(webScraper:isReadyWithState:)]) {
        [self.delegate webScraper:self isReadyWithState:state];
    }
}


@end
