//
//  UIWebView+Document.h
//  WebScraper
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Document)

/** Return the URL from the document
 */
- (NSURL*)URL;

/** Return the title from the document
 */
- (NSString*)title;

/** Return the first h1 from the document
 */
- (NSString*)h1;

- (NSString*)body;

@end
