//
//  HttpRequester.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearcherHttpRequester

- (void) httpGetFrom:(NSString *)urlString
andCompletionHandler:(void (^)(NSDictionary *__nullable dict))handler;

- (void) httpGetFrom:(NSString *)urlString
           withQuery:(NSArray<NSURLQueryItem*> *)queryItems
andCompletionHandler:(void (^)(NSDictionary *__nullable dict)) handler;

@end

@interface HttpRequester : NSObject<SearcherHttpRequester>

@end
