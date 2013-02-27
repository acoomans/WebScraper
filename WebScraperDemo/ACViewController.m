//
//  ACViewController.m
//  WebScraperDemo
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACViewController.h"

@interface ACViewController ()
@property (nonatomic, strong) ACWebScrapingClient *client;
@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [[ACWebScrapingClient alloc] init];
    
    [self.client scrapURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]
                libraries:[@[
                           @"http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"
                           ] mutableCopy]
              evaluations:[@[
                            @[
                                @"document.getElementsByTagName('a')[11].click();",
                                @"return (document.getElementsByTagName('a')[11] ? true : false);"
                            ],
                            @[
                                @"return $('span.comment font')[0].innerHTML",
                                @"return ((typeof jQuery != 'undefined') && document.URL.substring(0, 36) == 'http://news.ycombinator.com/item?id=' ? true : false);"
                            ],
                           ] mutableCopy]
                     done:^(NSString *result) {
                         NSLog(@"result = %@", result);
                     }];
}

@end
