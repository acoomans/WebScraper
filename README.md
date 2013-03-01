WebScraper
==========

iOS library for web scraping. This basically makes it possible to scrap any web page and thus, build an iOS app for any web site, even if it does not have an API.

_WebScraper_ uses a _UIWebView_ behind the scenes to do the scaping. This allows us to scrap web pages even if they're full of javascript (like web sites made with [backbone.js](http://backbonejs.org/)).

## Usage

### Client

The easiest way is to use the web scraping client. 
First instantiate it:

    self.client = [[ACWebScrapingClient alloc] init];

Then setup a web scraping operation:

    ACWebScrapingOperation *webScrapingOperation =
    [self.client scrapURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]
                libraries:[@[
                           @"http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js" // inject jquery in every page
                           ] mutableCopy]
              evaluations:[@[
                            @[
                                @"document.getElementsByTagName('a')[11].click();",                 // click on a link
                                @"return (document.getElementsByTagName('a')[11] ? true : false);"  // when the link is present in the DOM
                            ],
                            @[
                                @"return $('span.comment font')[0].innerHTML",
                                @"return ((typeof jQuery != 'undefined') && document.URL.substring(0, 36) == 'http://news.ycombinator.com/item?id=' ? true : false);"
                            ],
                           ] mutableCopy]
                     done:^(NSString *result) {
                         NSLog(@"result = %@", result);
                     }];

- _libraries_ may contain javascript code or an URL to javascript to inject in each page
- _evaluations_ is contains the javascript to be evaluated, when a condition is met
- _done_ is called with the result of the last evaluation

For debugging, you can display the UIWebView to see what the web scraping operation is doing:

    [self.view addSubview:webScrapingOperation.webScraperQueue.webScraper.webview];
    webScrapingOperation.webScraperQueue.webScraper.webview.frame = self.view.bounds;


### Web scraper

If for some reason, you prefer to use the scraper directly, you can do so.

First instantiate the webscraper and set its delegate:

    self.webScraper = [[ACWebScraper alloc] init];
    self.webScraper.delegate = self;

Open an URL:

    [self.webScraper openURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]];

When the scraper is ready, it will call the delegate's _webScraper:isReadyWithState:_
There you can evaluate some javascript code with _evaluate:_

    - (void)webScraper:(ACWebScraper*)webScraper isReadyWithState:(ACWebScraperState)state {
        if (state != ACWebScraperStateDOMLoaded) return;
    
        if ([webScraper.webview.URL.absoluteString isEqualToString:@"http://news.ycombinator.com/"]) {
            [self.webScraper evaluate:@"return document.getElementsByTagName('a')[9].innerHTML"];
            [self.webScraper evaluate:@"document.getElementsByTagName('a')[9].click()"];
        }
    }

If you have to wait for something, you can use _evaluate:when:_

    [self.webScraper evaluate:@"return document.getElementsByTagName('a')[9].innerHTML" 
                         when:@"return (document.getElementsByTagName('a')) ? true : false)";];

When evaluation is ready, the delegate's _webScraper:didEvaluate:withResult:_ will be called:

    - (void)webScraper:(ACWebScraper*)webScraper didEvaluate:(NSString*)evaluation withResult:(NSString*)result {
        NSLog(@"%@", result);
    }


## Documentation

install appledoc:

`brew install appledoc`

build the _WebScraperDocumentation_ target,

the documentation will be automatically added to Xcode.