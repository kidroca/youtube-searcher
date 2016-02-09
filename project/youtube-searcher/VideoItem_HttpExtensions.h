//
//  VideoItem_HttpExtensions.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoItemResult.h"

extern NSString *const VIDEO_ID_PATH;
extern NSString *const VIDEO_TITLE_PATH;
extern NSString *const VIDEO_DESCRIPION_PATH;
extern NSString *const VIDEO_THUMBNAIL_PATH;

@interface VideoItemResult (HttpExtensions)

@property(nonatomic) BOOL selected;

-(NSString *)getVideoUrl;

+(instancetype)videoWithDict:(NSDictionary *)dict;

-(void)markAsSelected;
-(void)unmarkAsSelected;

@end
