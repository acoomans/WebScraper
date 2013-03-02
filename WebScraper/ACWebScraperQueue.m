//
//  ACWebScraperQueue.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/25/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACWebScraperQueue.h"

@interface ACWebScraperQueue ()
- (void)loadLibraries;
- (void)dequeue;
@end


@implementation ACWebScraperQueue

- (id)init {
    self = [super init];
    if (self) {
        self.evaluationsQueue = [[NSMutableArray alloc] init];
        self.webScraper = [[ACWebScraper alloc] init];
        self.webScraper.delegate = self;
        self.libraries = [[NSMutableArray alloc] init];
        self.delegate = nil;
    }
    return self;
}

#pragma mark - operations

- (void)startScrapingAtURL:(NSURL*)url {
    [self.webScraper openURL:url];
    [self startScraping];
}

- (void)startScraping {
    [self loadLibraries];
    [self dequeue];
}

- (void)loadLibraries {
    NSString *l = nil;
    [self.libraries insertObject:@"function loadjs(f){var r=document.createElement('script');r.type='text/javascript';r.src=f;document.getElementsByTagName('head')[0].appendChild(r)};" atIndex:0];
    for (NSString *library in self.libraries) {
        if ([library hasPrefix:@"http"] || [library hasPrefix:@"file://"]) {
            l = [NSString stringWithFormat:@"loadjs('%@');", library];
        } else {
            l = library;
        }
        [self.webScraper load:l];
    }
}

- (void)dequeue {
    if (![self.evaluationsQueue count]) return;
    NSLog(@"WebScraperQueue: dequeue");
    
    NSString *evaluation = nil;
    NSString *when = nil;
    
    id item = self.evaluationsQueue[0];
    [self.evaluationsQueue removeObjectAtIndex:0];
    if ([item isKindOfClass:[NSString class]]) {
        evaluation = item;
    } else if ([item isKindOfClass:[NSDictionary class]]) {
        evaluation = item[@"evaluation"];
        when = item[@"when"];
    } else if ([item isKindOfClass:[NSArray class]]) {
        evaluation = item[0];
        when = item[1];
    }
    [self.webScraper evaluate:evaluation when:when];
}

#pragma mark - ACWebScraperDelegate


- (void)webScraper:(ACWebScraper*)webScraper isReadyWithState:(ACWebScraperState)state {
    if (state != ACWebScraperStateDOMLoaded) return;
    [self loadLibraries];    
}

- (void)webScraper:(ACWebScraper*)webScraper didEvaluate:(NSString*)evaluation withResult:(NSString*)result {
    if (![self.evaluationsQueue count]) {
        NSLog(@"WebScraperQueue: finished evaluating");
        if ([self.delegate respondsToSelector:@selector(webScraperQueue:didEvaluateQueueWithResult:)]) {
            [self.delegate webScraperQueue:self didEvaluateQueueWithResult:result];
        }
    } else {
        [self dequeue];
    }
}

@end
