//
//  PagedVideoCollection_HttpExtensions.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "PagedVideoCollectionResult.h"

extern NSString *const NEXT_PAGE_PATH;
extern NSString *const PREV_PAGE_PATH;
extern NSString *const VIDEO_COLLECTION_PATH;
extern NSString *const PAGE_INFO_PATH;

@interface PagedVideoCollectionResult ()

+(instancetype) pagedCollectionWithDict:(NSDictionary *)dict;

@end
