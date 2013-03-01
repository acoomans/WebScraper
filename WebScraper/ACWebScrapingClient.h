//
//  ACWebScrapingClient.h
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/26/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACWebScrapingOperation.h"

@interface ACWebScrapingClient : NSObject

@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (ACWebScrapingOperation*)scrapURL:(NSURL*)url
     libraries:(NSMutableArray*)libraries
   evaluations:(NSMutableArray*)evaluations
          done:(void (^)(NSString*result))done;

@end