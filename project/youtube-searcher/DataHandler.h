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

- (void)setHttpRequester:(NSObject<SearcherHttpRequester> *)httpRequester;

+ (instancetype) sharedHandler;

-(PagedVideoCollectionResult *) searchFor:(VideoQueryModel *)query;

-(PagedVideoCollectionResult *) getPageFor:(NSString *) pageToken;

@end
