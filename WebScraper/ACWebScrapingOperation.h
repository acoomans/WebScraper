//
//  ACWebScrapingOperation.h
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACWebScraperQueue.h"

@interface ACWebScrapingOperation : NSOperation <ACWebScraperQueueDelegate>

@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isExecuting;

@property (nonatomic, strong) ACWebScraperQueue *webScraperQueue;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *libraries;
@property (nonatomic, strong) NSMutableArray *evaluationsQueue;

@property (copy) void(^done)(NSString*result);

- (id)initWithURL:(NSURL*)url
        libraries:(NSMutableArray*)libraries
 evaluationsQueue:(NSMutableArray*)evaluationsQueue
             done:(void (^)(NSString*result))done;

@end
