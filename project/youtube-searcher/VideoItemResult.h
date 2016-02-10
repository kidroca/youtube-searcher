//
//  VideoItemResult.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoItemResult : NSObject

@property(strong, nonatomic) NSString *youtubeId;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *videoDescription;
@property(strong, nonatomic) NSString *thumbnailUrl;
@property(strong, nonatomic) NSData *thumbnailData;

-(instancetype)initWithVideoId:(NSString *)videoId
                         title:(NSString *)title
                   description:(NSString *)description
               andThumbnailUrl:(NSString *) thumbnailUrl;

+(instancetype)videoWithVideoId:(NSString *)videoId
                          title:(NSString *)title
                    description:(NSString *)description
                andThumbnailUrl:(NSString *) thumbnailUrl;

@end