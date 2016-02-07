//
//  PagedVideoCollectionResult.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageInfo.h"	
#import "VideoItemResult.h"
#import "VideoItem_HttpExtensions.h"

@interface PagedVideoCollectionResult : NSObject

@property(strong, nonatomic) NSString *nextPageToken;
@property(strong, nonatomic) NSString *prevPageToken;
@property(strong, nonatomic) PageInfo *pageInfo;
@property(strong, nonatomic) NSMutableArray<VideoItemResult *> *items;

@end
