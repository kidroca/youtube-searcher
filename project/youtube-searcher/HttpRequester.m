//
//  HttpRequester.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "HttpRequester.h"

@implementation HttpRequester

- (void) httpGetFrom:(NSString *)urlString
andCompletionHandler:(void (^)(NSDictionary * _Nullable))handler {
    [self httpGetFrom:urlString withQuery:nil andCompletionHandler:handler];
}

// The actual workhorse
- (void) httpGetFrom:(NSString *)urlString
           withQuery:(NSArray<NSURLQueryItem *> *)queryItems
andCompletionHandler:(void (^)(NSDictionary * _Nullable))handler{
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:urlString];
    [self appendQuery:queryItems to:urlComponents];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:urlComponents.URL];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:req
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Request resulted in error: %@", error);
                        return;
                    }
                    
                    NSLog(@"Yess Rabot1!!!");
                    NSDictionary *dataDict =
                    [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
                
                    
                    NSLog(@"ResponseUrl: %@ \n\n Data: %@",response.URL, dataDict);
                    handler(dataDict);
                }]
     resume];
}

- (void) appendQuery:(id)query to:(NSURLComponents *)urlComponents{
    
    if ([query isMemberOfClass:[NSString class]]) {
        [urlComponents setQuery: query];
    } else if ([query isKindOfClass:[NSArray class]]) {
        [urlComponents setQueryItems: query];
    }
}

@end
