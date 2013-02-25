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



@interface ACWebScraper ()
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) ACWebScraperState state;
- (void)evaluateWhen:(NSDictionary*)e;
@end

@implementation ACWebScraper

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
        self.webview = [[UIWebView alloc] init];
        self.webview.delegate = self;
        self.state = ACWebScraperStateNull;
    }
    return self;
}


#pragma mark - 

- (void)openURL:(NSURL*)url {
    self.state = ACWebScraperStateNull;
    [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)load:(NSString*)evaluation {
    [self.webview stringByEvaluatingJavaScriptFromString:evaluation];
}

- (void)evaluate:(NSString*)evaluation {
    NSString *result = [self.webview stringByEvaluatingJavaScriptFromString:[evaluation wrapInFunction]];
    if ([self.delegate respondsToSelector:@selector(webScraper:didEvaluate:withResult:)]) {
        [self.delegate webScraper:self didEvaluate:evaluation withResult:result];
    }
}

- (void)evaluate:(NSString*)evaluation when:(NSString*)when {
    [self evaluateWhen:@{@"evaluation":evaluation, @"when":when}];
}

- (void)evaluateWhen:(NSDictionary*)e { // wrapper for performSelector
    NSString *evaluation = e[@"evaluation"];
    NSString *when = e[@"when"];
    if ([@"true" caseInsensitiveCompare:[self.webview stringByEvaluatingJavaScriptFromString:[when wrapInFunction]]] == NSOrderedSame) {
        [self evaluate:evaluation];
    } else {
        [self performSelector:@selector(evaluateWhen:) withObject:e afterDelay:1];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self documentReadyWithState:ACWebScraperStateWebViewLoaded];
    
    [webView stringByEvaluatingJavaScriptFromString:ACEvaluateDomReadyScript];
    [webView stringByEvaluatingJavaScriptFromString:ACEvaluateDomLoadedScript];
    [self pollState];
}

#pragma mark - document state

- (void)pollState {
    if ([@"true" caseInsensitiveCompare:[self.webview stringByEvaluatingJavaScriptFromString:@"document.UIWebViewIsDomReady"]] == NSOrderedSame) {
        [self documentReadyWithState:ACWebScraperStateDOMReady];
    }
    
    if ([@"true" caseInsensitiveCompare:[self.webview stringByEvaluatingJavaScriptFromString:@"document.UIWebViewIsDomLoaded"]] == NSOrderedSame) {
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
