WebScraper
==========

iOS library for web scraping.

## Usage

First instantiate the webscraper and set its delegate:

    self.webScraper = [[ACWebScraper alloc] init];
    self.webScraper.delegate = self;

Open an URL:

    [self.webScraper openURL:[NSURL URLWithString:@"http://news.ycombinator.com/"]];

When the scraper is ready, it will call the delegate's _webScraper:isReadyWithState:_ .
There you can evaluate some javascript code with _evaluate:_ :

    - (void)webScraper:(ACWebScraper*)webScraper isReadyWithState:(ACWebScraperState)state {
        if (state != ACWebScraperStateDOMLoaded) return;
    
        if ([webScraper.webview.URL.absoluteString isEqualToString:@"http://news.ycombinator.com/"]) {
            [self.webScraper evaluate:@"return document.getElementsByTagName('a')[9].innerHTML"];
            [self.webScraper evaluate:@"document.getElementsByTagName('a')[9].click()"];
        }
    }

If you have to wait for something, you can use _evaluate:when:_ :

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