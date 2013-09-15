//
//  SUWebParser.m
//  SSUNS
//
//  Created by James on 2013-08-21.
//  Copyright (c) 2013 James. All rights reserved.
//

#define ssunsPre @"http://www.ssuns.org"
#import "SUWebParser.h"
#import <TFHpple.h>

@implementation SUWebParser

+(void)parseCommitteeListWithData:(NSData*)data withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)error{
    TFHpple *commParser = [TFHpple hppleWithHTMLData:data];
    NSString *commXpathQueryString = @"//div[@id='content']";
    NSArray *commRootNodes = [commParser searchWithXPathQuery:commXpathQueryString];
    
    if ([commRootNodes count]==0) {
        suresponse(nil);
    }
    TFHppleElement *rootElement = [commRootNodes objectAtIndex:0];
    NSMutableArray* categoryArray = [[NSMutableArray alloc] init];
    NSMutableArray* groupArray = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in [rootElement children]) {
        if([[element tagName]isEqualToString:@"h2"]){
            for (TFHppleElement *pelement in [element children]) {
                if ([[pelement tagName]isEqualToString:@"text"]) {
                    NSString* pstring = [[pelement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSLog(@"%@",pstring);
                    [categoryArray addObject:pstring];
                }
            }
        }
        
        if ([[element tagName] isEqualToString:@"ul"]) {
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            for (TFHppleElement *celement in [element children]){
                if ([[celement tagName]isEqualToString:@"li"]) {
                    NSMutableDictionary* itemDict = [[NSMutableDictionary alloc]init];
                    for (TFHppleElement* belement in [celement children]) {
                        if ([[belement tagName]isEqualToString:@"a"]) {
                            NSString* urlString = [[belement attributes]objectForKey:@"href"];
                            [itemDict setValue:[ssunsPre stringByAppendingString:urlString] forKey:@"href"];
                            
                            NSLog(@"%@",urlString);
                            for (TFHppleElement* aelement in [belement children]) {
                                if ([[aelement tagName]isEqualToString:@"img"]) {
                                    NSString* imgString = [[aelement attributes]objectForKey:@"src"];
                                    [itemDict setValue:[ssunsPre stringByAppendingString:imgString] forKey:@"img"];
                                    NSLog(@"%@",imgString);
                                }else if ([[aelement tagName]isEqualToString:@"h5"]){
                                    NSString* dstring = [[[aelement children] objectAtIndex:0] content];
                                    [itemDict setValue:dstring forKey:@"text"];
                                    NSLog(@"%@",dstring);
                                }
                            }
                        }
                    }
                    [tempArray addObject:itemDict];
                }
            }
            [groupArray addObject:tempArray];
        }
        
    }
    NSDictionary* retDict = [[NSDictionary alloc]initWithObjectsAndKeys:categoryArray,@"categories",groupArray,@"groups", nil];
    suresponse(retDict);
}

+(void)loadCommitteesListWithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror{
    
    NSURL *requestUrl = [NSURL URLWithString:[ssunsPre stringByAppendingString:@"/committees-list"]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for Committee");
        responseData = [cachedURLResponse data];
        [SUWebParser parseCommitteeListWithData:responseData withResponse:suresponse andError:suerror];
        
    }
    else //if no cache get it from the server.
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [SUWebParser parseCommitteeListWithData:data withResponse:suresponse andError:suerror];
            
            //cache received data
            cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            //store in cache
            [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
            
        }];
    }
    
}

+(void)parseCommitteeWithData:(NSData*)data withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)error{
    TFHpple *commParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *commXpathQueryString = @"//div[@id='content']/h1";
    NSArray *commRootNodes = [commParser searchWithXPathQuery:commXpathQueryString];
    
    if ([commRootNodes count]==0) {
        suresponse(nil);
    }
    NSMutableDictionary* retDict = [[NSMutableDictionary alloc]init];
    
    TFHppleElement *rootElement = [commRootNodes objectAtIndex:0];
    for (TFHppleElement *pelement in [rootElement children]) {
        if ([[pelement tagName]isEqualToString:@"text"]) {
            NSString* pstring = [[pelement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSLog(@"%@",pstring);
            [retDict setValue:pstring forKey:@"title"];
        }
    }
    
    NSString* descriptionXpathQueryString = @"//div[@id='content']/p";
    NSArray* desNodes = [commParser searchWithXPathQuery:descriptionXpathQueryString];
    if ([desNodes count] == 0) {
        suresponse(retDict);
    }
    NSMutableString* tmpString = [[NSMutableString alloc]init];
    for(TFHppleElement *descElement in desNodes){
        for (TFHppleElement *pelement in [descElement children]) {
           if ([[pelement tagName]isEqualToString:@"text"]) {
                NSString* pstring = [[pelement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//                NSLog(@"%@",pstring);
                [tmpString appendString:pstring];
            }
        }
    }
    
    [retDict setValue:tmpString forKey:@"content"];

    NSString* bgXpathQueryString = @"//div[@id='content']/p/a";
    NSArray* hrefNodes = [commParser searchWithXPathQuery:bgXpathQueryString];
    if ([hrefNodes count] == 0) {
        suresponse(retDict);
    }
    NSString* urlString = [[NSString alloc]init];
    for(TFHppleElement *hrefElement in hrefNodes){
        urlString = [hrefElement.attributes objectForKey:@"href"];
        if ([urlString rangeOfString:@"pdf"].location != NSNotFound) {
            [retDict setValue:[ssunsPre stringByAppendingString:urlString] forKey:@"bgUrl"];
        }
    }
    NSLog(urlString);
    suresponse(retDict);

}


+(void)loadCommittee:(NSString*)committeeString withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror{
    
    NSURL *requestUrl = [NSURL URLWithString:committeeString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for committee");
        responseData = [cachedURLResponse data];
        [SUWebParser parseCommitteeWithData:responseData withResponse:suresponse andError:suerror];
        
    }
    else //if no cache get it from the server.
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [SUWebParser parseCommitteeWithData:data withResponse:suresponse andError:suerror];
            
            //cache received data
            cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            //store in cache
            [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
            
        }];
    }
    
}

+(void)parseItinerarywithData:(NSData*)data withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)error{
    TFHpple *itinParser = [TFHpple hppleWithHTMLData:data];
    NSString *itinXpathQueryString = @"//div[@id='content']";
    NSArray *itinNodes = [itinParser searchWithXPathQuery:itinXpathQueryString];
    
    if ([itinNodes count]==0) {
        suresponse(nil);
    }
    
    NSMutableArray* dayArray = [[NSMutableArray alloc] init];
    NSMutableArray* timeArray = [[NSMutableArray alloc] init];
    
    TFHppleElement *rootElement = [itinNodes objectAtIndex:0];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in [rootElement children]) {
        if ([[element tagName] isEqualToString:@"div"]) {
                //new day
            for (TFHppleElement *celement in [element children]){
                if ([[celement tagName]isEqualToString:@"b"]) {
                    for (TFHppleElement* belement in [celement children]) {
                        if ([[belement tagName]isEqualToString:@"text"]) {
                            NSString* dstring = [belement content];
                            NSLog(@"%@",dstring);
                            [dayArray addObject:dstring];
                            if ([tempArray count]>0) {
                                [timeArray addObject:[[NSArray alloc] initWithArray:tempArray]];
                                [tempArray removeAllObjects];
                            }
                        }
                    }
                }
            }
        }
        if([[element tagName]isEqualToString:@"p"]){
            for (TFHppleElement *pelement in [element children]) {
                if ([[pelement tagName]isEqualToString:@"text"]) {
                    NSString* pstring = [[pelement content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSLog(@"%@",pstring);
                    [tempArray addObject:pstring];
                }
            }
        }
        if ([[element tagName]isEqualToString:@"text"]) {
            NSString* pstring = [[element content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([pstring length]>0) {
                NSLog(@"%@",pstring);
                [tempArray addObject:pstring];
            }
        }
    
    }
    [timeArray addObject:[[NSArray alloc] initWithArray:tempArray]];
    [tempArray removeAllObjects];
    NSDictionary* retDict = [[NSDictionary alloc]initWithObjectsAndKeys:dayArray,@"days",timeArray,@"times", nil];
    suresponse(retDict);
}

+(void)loadItinerarywithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror{
    
    NSURL *requestUrl = [NSURL URLWithString:[ssunsPre stringByAppendingString:@"/itinerary"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for Itinerary");
        responseData = [cachedURLResponse data];
        [SUWebParser parseItinerarywithData:responseData withResponse:suresponse andError:suerror];

    }
    else //if no cache get it from the server.
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [SUWebParser parseItinerarywithData:data withResponse:suresponse andError:suerror];
            
            //cache received data
            cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            //store in cache
            [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
        }];
    }
}
/*
+(void)parseMapWithData:(NSData*)data withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)error{
    TFHpple *commParser = [TFHpple hppleWithHTMLData:data];
    NSString *commXpathQueryString = @"//div[@id='content']";
    
    NSArray *commRootNodes = [commParser searchWithXPathQuery:commXpathQueryString];
    
    if ([commRootNodes count]==0) {
        suresponse(nil);
    }
    TFHppleElement *rootElement = [commRootNodes objectAtIndex:0];
    NSString *retString = [rootElement.raw stringByReplacingOccurrencesOfString:@"img src=\"/" withString:[NSString stringWithFormat:@"img src=\"%@/",ssunsPre]];
    NSDictionary* retDict = [[NSDictionary alloc]initWithObjectsAndKeys:retString,@"content", nil];
    suresponse(retDict);

}

+(void)loadMapWithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror{
        
    NSURL *requestUrl = [NSURL URLWithString:[ssunsPre stringByAppendingString:@"/hotel-dir"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for Itinerary");
        responseData = [cachedURLResponse data];
        [SUWebParser parseMapWithData:responseData withResponse:suresponse andError:suerror];
        
    }
    else //if no cache get it from the server.
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [SUWebParser parseMapWithData:data withResponse:suresponse andError:suerror];
            
            //cache received data
            cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            //store in cache
            [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
            
        }];
    }
    
}
*/

+(void)parseMapWithData:(NSData*)data withResponse:(SUBlockResponse)suresponse andError:(SUBlockError)error{
    TFHpple *commParser = [TFHpple hppleWithHTMLData:data];
    NSString *commXpathQueryString = @"//div[@id='googlemap']";
    
    NSArray *commRootNodes = [commParser searchWithXPathQuery:commXpathQueryString];
    
    if ([commRootNodes count]==0) {
        suresponse(nil);
    }
    TFHppleElement *rootElement = [commRootNodes objectAtIndex:0];
    NSString *retString = [rootElement.raw stringByReplacingOccurrencesOfString:@"<div id=\"googlemap\" style=\"display:none\">" withString:[NSString stringWithFormat:@"",ssunsPre]];
    retString = [retString stringByReplacingOccurrencesOfString:@"</div>" withString:[NSString stringWithFormat:@"",ssunsPre]];
    NSDictionary* retDict = [[NSDictionary alloc]initWithObjectsAndKeys:retString,@"content", nil];
    suresponse(retDict);
    
}

+(void)loadMapWithResponse:(SUBlockResponse)suresponse andError:(SUBlockError)suerror{
    
    NSURL *requestUrl = [NSURL URLWithString:[ssunsPre stringByAppendingString:@"/hotel-dir"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
    
    __block NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    NSData *responseData;
    
    //check if has cache
    if(cachedURLResponse && cachedURLResponse != (id)[NSNull null])
    {
        NSLog(@"findCache for map");
        responseData = [cachedURLResponse data];
        [SUWebParser parseMapWithData:responseData withResponse:suresponse andError:suerror];
        
    }
    else //if no cache get it from the server.
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [SUWebParser parseMapWithData:data withResponse:suresponse andError:suerror];
            
            //cache received data
            cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
            //store in cache
            [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:request];
            
        }];
    }
    
}
@end
