//
//  ACWebScrapingClient.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACWebScrapingClient.h"
#import "ACWebScrapingOperation.h"


@interface ACWebScrapingClient ()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation ACWebScrapingClient

- (id)init {
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
        self.shouldShareWebView = NO;
        self.webview = nil;
        self.skipIfWhenFails = NO;
    }
    return self;
}

/*
- (UIWebView*)webview {
    if (!_webview) {
        if ([NSThread isMainThread]) {
            self.webview = [[UIWebView alloc] init];
        } else {
            __block __weak ACWebScrapingClient *this = self;
            dispatch_sync(dispatch_get_main_queue(), ^{
                this.webview = [[UIWebView alloc] init];
            });
        }
    }
    return _webview;
}
*/

- (ACWebScrapingOperation*)scrapURL:(NSURL*)url
                          libraries:(NSArray*)libraries
                        evaluations:(NSArray*)evaluations
                            success:(void (^)(NSString*result))success
                            failure:(void (^)(NSError **error))failure
{
    
    ACWebScrapingOperation *webScrapingOperation = [[ACWebScrapingOperation alloc] initWithURL:url
                                                                                     libraries:libraries
                                                                                   evaluations:evaluations
                                                                                       success:success
                                                                                       failure:failure];
    
    webScrapingOperation.delegate = self;
    
    if (self.skipIfWhenFails) {
        webScrapingOperation.webScraperQueue.stopIfWhenFails = YES;
    }
    
    if (self.shouldShareWebView && !self.webview) {
        self.webview = webScrapingOperation.webScraperQueue.webScraper.webview;
    }
    
    [self.operationQueue addOperation:webScrapingOperation];
    return webScrapingOperation;
}

- (void)setShouldShareWebView:(BOOL)shouldShareWebView {
    _shouldShareWebView = shouldShareWebView;
    self.operationQueue.maxConcurrentOperationCount = shouldShareWebView ? 1 : NSOperationQueueDefaultMaxConcurrentOperationCount;
}

#pragma mark - ACWebScrapingOperationDelegate

- (UIWebView*)webScrapingOperationShouldUseWebView:(ACWebScrapingOperation*)webScrapingOperation {
    if (self.shouldShareWebView) {
        return self.webview;
    }
    return nil;
}

@end
