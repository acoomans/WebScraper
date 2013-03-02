//
//  ACWebScrapingOperation.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACWebScrapingOperation.h"

@interface ACWebScrapingOperation ()

@end

@implementation ACWebScrapingOperation

- (id)init {
    self = [self initWithURL:nil
                   libraries:nil
                 evaluations:nil
                        done:nil];
    return self;
}

- (id)initWithURL:(NSURL*)url
        libraries:(NSArray*)libraries
      evaluations:(NSArray*)evaluations
             done:(void (^)(NSString*result))done
{
    self = [super init];
    if (self) {
        
        self.webScraperQueue = [[ACWebScraperQueue alloc] init];
        self.webScraperQueue.delegate = self;
        
        self.url = url;
        self.libraries = libraries;
        self.evaluationsQueue = evaluations;
        
        self.isExecuting = NO;
        self.isFinished = NO;
        self.done = done;
    }
    return self;
}
- (void)start {
    self.isExecuting = YES;
    
    self.webScraperQueue.libraries = [self.libraries mutableCopy];
    self.webScraperQueue.evaluationsQueue = [self.evaluationsQueue mutableCopy];
    
    [self.webScraperQueue startScrapingAtURL:self.url];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - ACWebScraperDelegate

- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didEvaluateQueueWithResult:(NSString*)result {
    if (self.done) {
        self.done(result);
    }
    self.isExecuting = NO;
    self.isFinished = YES;
}


@end
