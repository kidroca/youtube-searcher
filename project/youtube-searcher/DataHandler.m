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
@property(strong, nonatomic) id<SearcherHttpRequester> requester;

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

-(void)setHttpRequester:(NSObject<SearcherHttpRequester> *)httpRequester{
    _requester = httpRequester;
}

-(NSArray *)getResultOrders{
    NSArray *orderTypes =
    [NSArray arrayWithObjects:@"date", @"rating", @"relevance", @"title", @"viewCount", nil];
    
    return orderTypes;
}

-(void)searchFor:(VideoQueryModel *)videoQuery withHandler:(void (^)(NSDictionary * _Nullable))handler{
    NSMutableArray *query = [self getQueryWithDefaultParameters];
    
    [query addObjectsFromArray:[videoQuery getQueryItems]];
    
    [self.requester httpGetFrom:self.baseUrl withQuery:query andCompletionHandler:handler];
}

-(void)getPageFor:(NSString *)pageToken withHandler:(void (^)(NSDictionary * _Nullable))handler{
    NSMutableArray *query = [self getQueryWithDefaultParameters];
    
    [query addObject:[NSURLQueryItem queryItemWithName:@"pageToken" value:pageToken]];
    
    [self.requester httpGetFrom:self.baseUrl withQuery:query andCompletionHandler:handler];
}

-(NSMutableArray *) getQueryWithDefaultParameters{
    NSMutableArray *queryItems = [[NSMutableArray alloc] init];
    
    // Add required query parameters
    NSURLQueryItem *key = [NSURLQueryItem queryItemWithName:@"key" value:self.apiKey];
    NSURLQueryItem *part = [NSURLQueryItem queryItemWithName:@"part" value:@"snippet"];
    NSURLQueryItem *type = [NSURLQueryItem queryItemWithName:@"type" value:@"video"];
    // Restriction to only include data fields of interest and reduce traffic
    NSURLQueryItem *fields =
    [NSURLQueryItem queryItemWithName:@"fields"
                                value:@"items(id,snippet),nextPageToken,prevPageToken"];
    // Todo get this value from user settings
    NSURLQueryItem *resultsPerPage = [NSURLQueryItem queryItemWithName:@"maxResults" value:@"10"];
    
    [queryItems addObject:key];
    [queryItems addObject:part];
    [queryItems addObject:type];
    [queryItems addObject:fields];
    [queryItems addObject:resultsPerPage];
    
    return queryItems;
}

-(void)savePlaylist:(NSString *) name withVideos:(NSArray *) videos{
    NSEntityDescription *entity = [NSEntityDescription entityForName:PLAYLIST_ENTITY_KEY
                                              inManagedObjectContext:self.getManagedContext];
    
    NSManagedObject *playlist = [[NSManagedObject alloc] initWithEntity:entity
                                         insertIntoManagedObjectContext:self.getManagedContext];
    
    NSMutableSet *set = [NSMutableSet setWithArray:videos];
    [playlist setValue:set forKey:@"videos"];
    [playlist setValue:name forKey:@"name"];
    
    NSError *err = nil;
    [[self getManagedContext] save:&err];
    
    if (err) {
        NSException *ex = [NSException exceptionWithName:@"Database error" reason:[NSString stringWithFormat:@"Failed saving to the database: %@", err]  userInfo:nil];
        
        [ex raise];
    }
}

- (NSArray *) loadPlaylistSkiping:(NSInteger)skip andTaking:(NSInteger)take{
    NSFetchRequest *fetech = [NSFetchRequest fetchRequestWithEntityName:PLAYLIST_ENTITY_KEY];
    fetech.fetchOffset = skip;
    fetech.fetchLimit = take;
    
    NSError *err = nil;
    
    NSArray *playlists = [[self getManagedContext] executeFetchRequest:fetech error:&err];
    
    if(err){
        NSException *ex = [NSException exceptionWithName:@"Database error" reason:[NSString stringWithFormat:@"Failed fetching from the database: %@", err]  userInfo:nil];
        
        [ex raise];
    }
    
    return playlists;
}

//-(NSManagedObject *) findPlaylist:(NSString *)name{
//    NSFetchRequest *fetech = [NSFetchRequest fetchRequestWithEntityName:PLAYLIST_ENTITY_KEY];
//}

-(NSManagedObjectContext *)getManagedContext{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate.managedObjectContext;
}
@end
