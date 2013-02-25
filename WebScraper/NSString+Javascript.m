//
//  NSString+Javascript.m
//  WebScraper
//
//  Created by Arnaud Coomans on 2/24/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "NSString+Javascript.h"

@implementation NSString (Javascript)

- (NSString*)wrapInFunction {
    return [NSString stringWithFormat:@"var eval = function(){ %@; }; eval();", self];
}

@end
