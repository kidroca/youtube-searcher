	//
//  HttpRequester.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "HttpRequester.h"

@interface HttpRequester(){
    
    NSURL *_baseUrl;
    NSString *_queryString;
    NSMutableArray<NSURLQueryItem*> *_queryItems;
}

@end

@implementation HttpRequester

- (instancetype)initWithBaseUrl:(NSString *)baseUrl {
    if (self = [super init]) {
        [self setBaseUrlTo:baseUrl];
    }
    
    return self;
}

- (void) setBaseUrlTo:(NSString *) urlString{
    _baseUrl = [NSURL URLWithString:urlString];
}

- (void) setQueryStringTo:(NSString *)query{
    _queryString = query;
//    _queryItems = nil;
}

- (void) setQueryStringWith:(NSArray<NSURLQueryItem *> *)queryItems{
    _queryItems = [NSMutableArray arrayWithArray:queryItems];
}

- (void)addQueryItemWithValue:(NSString *)value forKey:(NSString *)key{
    if (!_queryItems) {
        _queryItems = [[NSMutableArray alloc] init];
    }

    NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:key value:value];

    // Remove if exists
    NSInteger index = 0;
    for (int i = 0; i < _queryItems.count; i++) {
        if ([_queryItems[i].name isEqualToString:key]) {
            index = i;
        }
    }
    
    if (index) {
        // update
        _queryItems[index] = item;
    } else {
        // add
        [_queryItems addObject:item];
    }
}

+ (instancetype) httpRequesterWithBaseUrl:(NSString *)baseUrl{
    return [[self alloc] initWithBaseUrl:baseUrl];
}

- (void) httpGetDefault{
    if (!_baseUrl) {
        NSException *ex = [NSException exceptionWithName:@"HTTP Requester Exception" reason:@"Requested default GET without having a baseUrl set, set a value for base url before using this method" userInfo:nil];
        
        [ex raise];
    }
    
    NSURLComponents *urlComponents = [self getUrlComponents];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:urlComponents.URL];
    NSURLSession *session = [NSURLSession sharedSession];
}

- (void) httpGetFrom:(NSString *)urlString{
    NSURLComponents *urlComponents = [self getUrlComponentsWithPath:urlString];
    
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
                    
                    NSLog(@"ResponseUrl: %@ Data: %@",response.URL, dataDict);
                }]
     resume];
}

- (NSURLComponents *) getUrlComponentsWithPath: (NSString *) path{
    NSURLComponents *urlComponents = nil;
    if (_baseUrl) {
        urlComponents = [self getUrlComponents];
        [urlComponents setPath:[NSString stringWithFormat:@"%@/%@", _baseUrl.path, path]];
    } else {
        urlComponents = [NSURLComponents componentsWithString:path];
        [self appendQueryTo:urlComponents];
    }
    
    return urlComponents;
}

- (NSURLComponents *) getUrlComponents{
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    NSLog(@"base url: host %@, path: %@, scheme: %@", _baseUrl.host, _baseUrl.path, _baseUrl.scheme);
    [urlComponents setHost:_baseUrl.host];
    [urlComponents setScheme:_baseUrl.scheme];
    [urlComponents setPath:  _baseUrl.path];
    
    [self appendQueryTo:urlComponents];
    
    return urlComponents;
}

- (void) appendQueryTo:(NSURLComponents *)urlComponents{
    // prefers collection over raw string...
    if (_queryItems) {
        [urlComponents setQueryItems: _queryItems];
    } else if (_queryString) {
        [urlComponents setQuery: _queryString];
    }
}

@end
