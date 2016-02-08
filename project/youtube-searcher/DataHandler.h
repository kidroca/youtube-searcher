//
//  DataHandler.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HttpRequester.h"
#import "PagedVideoCollectionResult.h"
#import "VideoQueryModel.h"
#import "Playlist.h"

extern NSString *const PLAYLIST_ENTITY_KEY;
extern NSString *const VIDEO_ENTITY_KEY;

@interface DataHandler : NSObject

- (void)setBaseUrl:(NSString *)baseUrl;

- (void)setApiKey:(NSString *)apiKey;

- (NSArray *)getResultOrders;

- (void)setHttpRequester:(NSObject<SearcherHttpRequester> *)httpRequester;

+ (instancetype) sharedHandler;

- (void)searchFor:(VideoQueryModel *)videoQuery withHandler:(void (^)(NSDictionary *__nullable dict)) handler;

- (void)getPageFor:(NSString *) pageToken
       withHandler:(void (^)(NSDictionary *__nullable dict)) handler;

-(void)savePlaylist:(NSString *) name withVideos:(NSArray *) videos;

- (NSArray *) loadPlaylistSkiping:(NSInteger)skip andTaking:(NSInteger)take;
@end
