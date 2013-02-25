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
@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webScraper = [[ACWebScraper alloc] init];
    self.webScraper.delegate = self;
    
    // let's add the webview to this controller's view so we can see what's happening; only for debugging
    [self.view addSubview:self.webScraper.webview];
    self.webScraper.webview.frame = self.view.bounds;
    
    [self.webScraper openURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]];
}

#pragma mark - ACWebScraperDelegate

- (void)webScraper:(ACWebScraper*)webScraper isReadyWithState:(ACWebScraperState)state {
    if (state != ACWebScraperStateDOMLoaded) return;
    
    if ([webScraper.webview.URL.absoluteString isEqualToString:@"http://news.ycombinator.com/"]) {
        [self.webScraper evaluate:@"return document.getElementsByTagName('a')[9].innerHTML"];
        [self.webScraper evaluate:@"document.getElementsByTagName('a')[9].click()"];
    }
}

- (void)webScraper:(ACWebScraper*)webScraper didEvaluate:(NSString*)evaluation withResult:(NSString*)result {
    NSLog(@"------------");
    NSLog(@"%@", evaluation);
    NSLog(@"result = %@", result);
}


@end
