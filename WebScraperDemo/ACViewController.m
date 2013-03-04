//
//  ACViewController.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACViewController.h"
#import "ACWebScraping.h"

@interface ACViewController ()
@property (nonatomic, strong) ACWebScrapingClient *client;
@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self singleOperation];
    //[self concurrentOperations];
}


- (void)singleOperation {
    
    self.client = [[ACWebScrapingClient alloc] init];
    ACWebScrapingOperation *webScrapingOperation = nil;
    
    webScrapingOperation =
    [self.client scrapURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]
                libraries:@[
                    @"http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"
                ]
              evaluations:@[
                    @[
                        @"document.getElementsByTagName('a')[11].click();",
                        @"return (document.getElementsByTagName('a')[11] ? true : false);"
                    ],
                    @[
                        @"return $('span.comment font')[0].innerHTML",
                        @"return ((typeof jQuery != 'undefined') && document.URL.substring(0, 36) == 'http://news.ycombinator.com/item?id=' ? true : false);"
                    ],
                ]
                     done:^(NSString *result) {
                         NSLog(@"hacker news result = %@", result);
                     }];
    
    // let's add the webview to this controller's view so we can see what's happening; only for debugging
    [self.view addSubview:webScrapingOperation.webScraperQueue.webScraper.webview];
    webScrapingOperation.webScraperQueue.webScraper.webview.frame = self.view.bounds;
}


- (void)concurrentOperations {
    
    CGRect frame = self.view.bounds;
    
    self.client = [[ACWebScrapingClient alloc] init];
    self.client.shouldShareWebView = NO;
    
    if (!self.client.shouldShareWebView) {
        frame.size.height /= 2;
    }
    
    ACWebScrapingOperation *webScrapingOperation = nil;
    
    webScrapingOperation =
    [self.client scrapURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]
                libraries:@[
                        @"http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"
                ]
              evaluations:@[
                    @[
                        @"document.getElementsByTagName('a')[11].click();",
                        @"return (document.getElementsByTagName('a')[11] ? true : false);"
                    ],
                    @[
                        @"return $('span.comment font')[0].innerHTML",
                        @"return ((typeof jQuery != 'undefined') && document.URL.substring(0, 36) == 'http://news.ycombinator.com/item?id=' ? true : false);"
                    ],
                ]
                     done:^(NSString *result) {
                         NSLog(@"hacker news result = %@", result);
                     }];
    
    // let's add the webview to this controller's view so we can see what's happening; only for debugging
    [self.view addSubview:webScrapingOperation.webScraperQueue.webScraper.webview];
    webScrapingOperation.webScraperQueue.webScraper.webview.frame = frame;
    
    webScrapingOperation =
    [self.client scrapURL:[NSURL URLWithString:@"http://slashdot.org/"]
                libraries:nil
              evaluations:@[
                    @[
                        @"document.getElementsByTagName('h2')[0].getElementsByTagName('a')[0].click()",
                        @2
                    ],
                    @[
                        @"document.getElementsByClassName('tag-bar')[0].getElementsByTagName('a')[1].click()",
                        @2
                    ],
                    @[@"return document.URL", @1]
                ]
                     done:^(NSString *result) {
                         NSLog(@"slashdot result = %@", result);
                     }];
    
    // let's add the webview to this controller's view so we can see what's happening; only for debugging
    if (!self.client.shouldShareWebView) {
        [self.view addSubview:webScrapingOperation.webScraperQueue.webScraper.webview];
        frame.origin.y += frame.size.height;
        webScrapingOperation.webScraperQueue.webScraper.webview.frame = frame;
    }
}

@end
