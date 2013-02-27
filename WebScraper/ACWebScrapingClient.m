//
//  ACWebScrapingClient.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACWebScrapingClient.h"
#import "ACWebScrapingOperation.h"

@implementation ACWebScrapingClient

- (id)init {
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    }
    return self;
}

- (void)scrapURL:(NSURL*)url
       libraries:(NSMutableArray*)libraries
     evaluations:(NSMutableArray*)evaluations
            done:(void (^)(NSString*result))done {
    
    
    ACWebScrapingOperation *webScrapingOperation = [[ACWebScrapingOperation alloc] initWithURL:url
                                                                                     libraries:libraries
                                                                              evaluationsQueue:evaluations
                                                                                          done:done];
    [self.operationQueue addOperation:webScrapingOperation];
}

@end
