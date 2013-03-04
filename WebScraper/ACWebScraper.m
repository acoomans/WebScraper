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

NSInteger const kACWebScraperWhenCountMax = 10;

@interface ACWebScraper ()
@property (nonatomic, assign) ACWebScraperState state;
@property (nonatomic, assign) NSInteger currentWhenCount;
- (void)evaluateWhen:(NSDictionary*)e;
- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)evaluation;
@end

@implementation ACWebScraper

@synthesize webview = _webview;

- (id)init {
    self = [super init];
    if (self) {
        self.state = ACWebScraperStateNull;
        self.whenCount = kACWebScraperWhenCountMax;
    }
    return self;
}

#pragma mark - accessors

- (void)setWebview:(UIWebView *)webview {
    @synchronized(self) {
        _webview = webview;
        webview.delegate = self;
    }
}

- (UIWebView*)webview {
    @synchronized(self) {
        if (!_webview) {
            if ([NSThread isMainThread]) {
                _webview = [[UIWebView alloc] init];
                _webview.delegate = self;
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    _webview = [[UIWebView alloc] init];
                    _webview.delegate = self;
                });
            }
        }
    }
    return _webview;
}

#pragma mark - 

- (NSString*)stringByEvaluatingJavaScriptFromString:(NSString*)evaluation {
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
    NSLog(@"WebScraper: evaluate");
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:[evaluation wrapInFunction]];
    if ([self.delegate respondsToSelector:@selector(webScraper:didEvaluate:withResult:)]) {
        [self.delegate webScraper:self didEvaluate:evaluation withResult:result];
    }
}

- (void)evaluate:(NSString*)evaluation when:(id)when {
    self.currentWhenCount = 0;
    if (!when) {
        [self evaluate:evaluation];
    } else {
        [self evaluateWhen:@{@"evaluation":evaluation, @"when":when}];
    }
}

- (void)evaluateWhen:(NSDictionary*)e { // wrapper for performSelector
    NSString *evaluation = e[@"evaluation"];
    id when = e[@"when"];
    
    if ([when isKindOfClass:[NSString class]]) {
        NSString *whenResult = [self stringByEvaluatingJavaScriptFromString:[when wrapInFunction]];
        if ([@"true" caseInsensitiveCompare:whenResult] == NSOrderedSame) {
            [self evaluate:evaluation];
        } else {
            if (self.currentWhenCount < self.whenCount) {
                NSLog(@"WebScraper: waiting to evaluate...");
                self.currentWhenCount++;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
                    [self evaluateWhen:e];
                });
            } else {
                NSLog(@"WebScraper: waited for too long, stopped. ");
                if ([self.delegate respondsToSelector:@selector(webScraper:didNotEvaluate:when:)]) {
                    [self.delegate webScraper:self didNotEvaluate:evaluation when:when];
                }
            }
        }
    } else if ([when isKindOfClass:[NSNumber class]]) {
        NSLog(@"WebScraper: waiting %@ seconds to evaluate...", when);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ([when floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
            [self evaluate:evaluation];
        });
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
