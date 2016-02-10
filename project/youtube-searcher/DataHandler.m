//
//  DataHandler.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "DataHandler.h"
#import "AppDelegate.h"

NSString *const PLAYLIST_ENTITY_KEY = @"Playlist";
NSString *const VIDEO_ENTITY_KEY = @"Video";

@interface DataHandler()

@property(strong, nonatomic) NSString *apiKey;
@property(strong, nonatomic) NSString *baseUrl;

@end

@implementation DataHandler

+(instancetype)sharedHandler{
    static DataHandler *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

-(void)setApiKey:(NSString *)value{
    _apiKey = value;
}

-(void)setBaseUrl:(NSString *)value{
    _baseUrl = value;
}

-(NSArray *)getResultOrders{
    NSArray *orderTypes =
    [NSArray arrayWithObjects:@"date", @"rating", @"relevance", @"title", @"viewCount", nil];
    
    return orderTypes;
}

-(void)searchFor:(VideoQueryModel *)videoQuery withHandler:(void (^)(NSDictionary * _Nullable))handler{
    NSMutableArray *query = [self applyDefaultParametersToQuery: [videoQuery getQueryItems]];
    
    [self.httpRequester httpGetFrom:self.baseUrl withQuery:query andCompletionHandler:handler];
}

-(void)getPageFor:(NSString *)pageToken withHandler:(void (^)(NSDictionary * _Nullable))handler{
    NSArray *pageQuery = @[[NSURLQueryItem queryItemWithName:@"pageToken" value:pageToken]];
    
    NSMutableArray *query = [self applyDefaultParametersToQuery: pageQuery];
    
    [self.httpRequester httpGetFrom:self.baseUrl withQuery:query andCompletionHandler:handler];
}

-(NSMutableArray *) applyDefaultParametersToQuery:(NSArray* )query{
    if(!query) {
        query = @[];
    }
    
    NSMutableArray *queryItems = [[NSMutableArray alloc] init];
    
    // Add required query parameters
    NSURLQueryItem *part = [NSURLQueryItem queryItemWithName:@"part" value:@"snippet"];
    NSURLQueryItem *type = [NSURLQueryItem queryItemWithName:@"type" value:@"video"];
    // Todo get this value from user settings
    NSURLQueryItem *resultsPerPage = [NSURLQueryItem queryItemWithName:@"maxResults" value:@"10"];
    
    // Restriction to only include data fields of interest and reduce traffic
    NSURLQueryItem *fields =
    [NSURLQueryItem queryItemWithName:@"fields"
                                value:@"items(id,snippet),nextPageToken,prevPageToken"];
    
    NSURLQueryItem *key = [NSURLQueryItem queryItemWithName:@"key" value:self.apiKey];
    
    [queryItems addObject:part];
    [queryItems addObject:type];
    [queryItems addObjectsFromArray:query];
    [queryItems addObject:resultsPerPage];
    [queryItems addObject:fields];
    [queryItems addObject:key];
    
    return queryItems;
}

-(void)createPlaylistWithName:(NSString *) name andVideos:(NSArray<VideoItemResult *> *) videos{
    PlaylistMO *playlist = (PlaylistMO *)[self.coreDataRequester createInstanceOfEntity:PLAYLIST_ENTITY_KEY];
    playlist.name = name;
    
    for (VideoItemResult *videoResult in videos) {
        VideoMO *video = (VideoMO *)[self.coreDataRequester
                                     createInstanceOfEntity:VIDEO_ENTITY_KEY];
        video.title = videoResult.title;
        video.youtubeId = videoResult.youtubeId;
        video.videoDescription = videoResult.videoDescription;
        video.thumbnailUrl = videoResult.thumbnailUrl;
        video.thumbnailData = videoResult.thumbnailData;
        
        [playlist addVideosObject: video];
    }
    
    [self.coreDataRequester saveChanges];
    NSLog(@"%@", playlist.videos);
}

@end
