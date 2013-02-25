//
//  UIWebView+Document.h
//  WebScraper
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Document)

- (NSURL*)URL;
- (NSString*)title;
- (NSString*)h1;

@end
