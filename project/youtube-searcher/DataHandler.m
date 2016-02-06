//
//  DataHandler.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "DataHandler.h"

@interface DataHandler()

@property(strong, nonatomic) NSString *apiKey;
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

-(void)setApiKey:(NSString *)apiKey{
    self.apiKey = apiKey;
}

-(void)setBaseUrl:(NSString *)baseUrl{
    if (!self.requester) {
        NSException *ex = [NSException exceptionWithName:@"DataHandler Exception" reason:@"Attempted to set baseUrl, but there is no httpRequest object, set a SearchHttpRequester object before calling this method" userInfo:nil];
        
        [ex raise];
    }
    
    [self.requester setBaseUrlTo:baseUrl];
}

-(void)setHttpRequester:(NSObject<SearcherHttpRequester> *)httpRequester{
    self.requester = httpRequester;
}

-(PagedVideoCollectionResult *)searchFor:(VideoQueryModel *)query{
    
}

-(PagedVideoCollectionResult *)getPageFor:(NSString *)pageToken{
    
}

@end
