//
//  DataHandler.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequester.h"
#import "PagedVideoCollectionResult.h"
#import "VideoQueryModel.h"

@interface DataHandler : NSObject

- (void)setBaseUrl:(NSString *)baseUrl;

- (void)setApiKey:(NSString *)apiKey;

- (NSArray *)getResultOrders;

- (void)setHttpRequester:(NSObject<SearcherHttpRequester> *)httpRequester;

+ (instancetype) sharedHandler;

- (void)searchFor:(VideoQueryModel *)videoQuery withHandler:(void (^)(NSDictionary *__nullable dict)) handler;

- (void)getPageFor:(NSString *) pageToken
       withHandler:(void (^)(NSDictionary *__nullable dict)) handler;

@end
