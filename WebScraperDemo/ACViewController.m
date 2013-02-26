//
//  ACViewController.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACViewController.h"

@interface ACViewController ()
@property (nonatomic, strong) ACWebScraper *webScraper;
@property (nonatomic, strong) ACWebScraperQueue *webScraperQueue;
@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webScraperQueue = [[ACWebScraperQueue alloc] init];
    self.webScraperQueue.delegate = self;
    
    // let's add the webview to this controller's view so we can see what's happening; only for debugging
    [self.view addSubview:self.webScraperQueue.webScraper.webview];
    self.webScraperQueue.webScraper.webview.frame = self.view.bounds;
    
    self.webScraperQueue.libraries = [@[
                                      @"http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"
                                       ] mutableCopy];
    
    self.webScraperQueue.evaluationsQueue = [@[
                                             @[
                                                @"document.getElementsByTagName('a')[11].click();",
                                                @"return (document.getElementsByTagName('a')[11] ? true : false);"
                                             ],
                                             @[
                                                @"return $('span.comment font')[0].innerHTML",
                                                @"return ((typeof jQuery != 'undefined') && document.URL.substring(0, 36) == 'http://news.ycombinator.com/item?id=' ? true : false);"
                                             ],
                                             
                                              ] mutableCopy];
    
    [self.webScraperQueue startScrapingAtURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]];
}

#pragma mark - ACWebScraperDelegate

- (void)webScraperQueue:(ACWebScraperQueue*)webScraperQueue didEvaluateQueueWithResult:(NSString*)result {
     NSLog(@"result = %@", result);
}

@end
