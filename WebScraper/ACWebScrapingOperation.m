//
//  ACWebScrapingOperation.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACWebScrapingOperation.h"

NSString * const ACWebScrapingOperationDidStartNotification = @"ACWebScrapingOperationDidStartNotification";
NSString * const ACWebScrapingOperationDidFinishNotification = @"ACWebScrapingOperationDidFinishNotification";


@interface ACWebScrapingOperation ()

@end

@implementation ACWebScrapingOperation

- (id)init {
    self = [self initWithURL:nil
                   libraries:nil
                 evaluations:nil
                     success:nil
                     failure:nil];
    return self;
}

- (id)initWithURL:(NSURL*)url
        libraries:(NSArray*)libraries
      evaluations:(NSArray*)evaluations
          success:(void (^)(NSString*result))success
          failure:(void (^)(NSError **error))failure
{
    self = [super init];
    if (self) {
        self.delegate = nil;
        
        self.webScraperQueue = [[ACWebScraperQueue alloc] init];
        self.webScraperQueue.delegate = self;
        
        self.url = url;
        self.libraries = libraries;
        self.evaluationsQueue = evaluations;
        
        self.isExecuting = NO;
        self.isFinished = NO;
        
        self.success = success;
        self.failure = failure;
    }
    return self;
}


#pragma mark - 

- (void)start {
    [super start];
    
    self.isExecuting = YES;
    
    if ([self.delegate respondsToSelector:@selector(webScrapingOperationShouldUseWebView:)]) {
        UIWebView *webView = [self.delegate webScrapingOperationShouldUseWebView:self];
        if (webView) {
            self.webScraperQueue.webScraper.webview = webView;
        }
    }
    
    self.webScraperQueue.libraries = [self.libraries mutableCopy];
    self.webScraperQueue.evaluationsQueue = [self.evaluationsQueue mutableCopy];
    
    [self.webScraperQueue startScrapingAtURL:self.url];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ACWebScrapingOperationDidStartNotification object:self userInfo:nil];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - ACWebScraperDelegate

- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didEvaluateQueueWithResult:(NSString*)result {

    [[NSNotificationCenter defaultCenter] postNotificationName:ACWebScrapingOperationDidFinishNotification object:self userInfo:nil];
    if (self.success) {
        self.success(result);
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    self.isExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    self.isFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didNotEvaluate:(NSString*)evaluation when:(NSString*)when {
    if (![self.evaluationsQueue count]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ACWebScrapingOperationDidFinishNotification object:self userInfo:nil];
        
        if (self.failure) {
            NSError *error = [NSError errorWithDomain:@"ACWebScrapingOperationError" code:101 userInfo:nil];
            self.failure(&error);
        }
        
        [self willChangeValueForKey:@"isExecuting"];
        self.isExecuting = NO;
        [self didChangeValueForKey:@"isExecuting"];
        
        [self willChangeValueForKey:@"isFinished"];
        self.isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
}


@end
