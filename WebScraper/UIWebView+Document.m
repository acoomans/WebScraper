//
//  UIWebView+Document.m
//  WebScraper
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "UIWebView+Document.h"
#import "NSString+Javascript.h"

@implementation UIWebView (Document)

- (NSURL*)URL {
    NSString *result = [self stringByEvaluatingJavaScriptFromString:[@"return document.URL" wrapInFunction]];
    return [NSURL URLWithString:result];
}

- (NSString*)title {
    return [self stringByEvaluatingJavaScriptFromString:[@"return document.title" wrapInFunction]];
}

- (NSString*)h1 {
    return [self stringByEvaluatingJavaScriptFromString:[@"return document.querySelectorAll('h1')[0]" wrapInFunction]];
}

- (NSString*)body {
    return [self stringByEvaluatingJavaScriptFromString:[@"return document.innerHTML" wrapInFunction]];
}

@end
