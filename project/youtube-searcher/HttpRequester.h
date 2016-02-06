//
//  HttpRequester.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequester : NSObject

+ (instancetype) httpRequesterWithBaseUrl:(NSString *)baseUrl;

- (instancetype) initWithBaseUrl:(NSString *)baseUrl;

- (void) setBaseUrlTo:(NSString *)urlString;

- (void) setQueryStringTo:(NSString *)query;

- (void) setQueryStringWith:(NSArray<NSURLQueryItem*> *) queryItems;

- (void) addQueryItemWithValue:(NSString *)value forKey:(NSString *)key;

- (void) httpGetFrom:(NSString *)urlString;

- (void) httpGetDefault;

@end
