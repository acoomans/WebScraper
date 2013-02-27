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
            evaluationsQueue:nil
                        done:nil];
    return self;
}

- (id)initWithURL:(NSURL*)url
        libraries:(NSMutableArray*)libraries
 evaluationsQueue:(NSMutableArray*)evaluationsQueue
done:(void (^)(NSString*result))done
{
    self = [super init];
    if (self) {
        self.isExecuting = NO;
        self.isFinished = NO;
        self.done = done;
        
        self.url = url;
        self.libraries = libraries;
        self.evaluationsQueue = evaluationsQueue;
        
    }
    return self;
}
- (void)start {
    self.isExecuting = YES;
    
    self.webScraperQueue = [[ACWebScraperQueue alloc] init];
    self.webScraperQueue.delegate = self;
    self.webScraperQueue.libraries = self.libraries;
    self.webScraperQueue.evaluationsQueue = self.evaluationsQueue;
    
    [self.webScraperQueue startScrapingAtURL:self.url];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - ACWebScraperDelegate

- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didEvaluateQueueWithResult:(NSString*)result {
    NSLog(@"result = %@", result);
    if (self.done) {
        self.done(result);
    }
    self.isExecuting = NO;
    self.isFinished = YES;
}


@end
