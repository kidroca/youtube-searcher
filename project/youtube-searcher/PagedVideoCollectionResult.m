//
//  PagedVideoCollectionResult.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "PagedVideoCollectionResult.h"

NSString *const NEXT_PAGE_PATH = @"nextPageToken";
NSString *const PREV_PAGE_PATH = @"prevPageToken";
NSString *const VIDEO_COLLECTION_PATH = @"items";
NSString *const PAGE_INFO_PATH = @"pageInfo";

@implementation PagedVideoCollectionResult

-(instancetype)init{
    if (self = [super init]) {
        self.items = [NSMutableArray array];
    }
    
    return self;
}

+(instancetype) pagedCollectionWithDict:(NSDictionary *)dict{
    PagedVideoCollectionResult *page = [[self alloc] init];
    page.prevPageToken = [dict valueForKeyPath:PREV_PAGE_PATH];
    page.nextPageToken = [dict valueForKeyPath:NEXT_PAGE_PATH];
    
    NSMutableArray *videos = [NSMutableArray array];
    NSArray *items = [dict valueForKeyPath:VIDEO_COLLECTION_PATH];
    for (id item in items) {
        VideoItemResult *video = [VideoItemResult videoWithDict:item];
        [videos addObject:video];
    }
    
    page.items = videos;
    
    return page;
}

@end
