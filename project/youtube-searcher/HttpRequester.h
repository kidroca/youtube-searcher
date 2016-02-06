//
//  HttpRequester.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearcherHttpRequester

- (void) setBaseUrlTo:(NSString *)urlString;
- (void) setQueryStringWith:(NSArray<NSURLQueryItem*> *) queryItems;
- (void) httpGetFrom:(NSString *)urlString;
- (void) httpGetDefault;

@end

@interface HttpRequester : NSObject<SearcherHttpRequester>

+ (instancetype) httpRequesterWithBaseUrl:(NSString *)baseUrl;

- (instancetype) initWithBaseUrl:(NSString *)baseUrl;

- (void) setQueryStringTo:(NSString *)query;

- (void) addQueryItemWithValue:(NSString *)value forKey:(NSString *)key;

@end
