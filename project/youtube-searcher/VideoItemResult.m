//
//  VideoItemResult.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "VideoItemResult.h"

NSString *const VIDEO_ID_PATH = @"id.videoId";
NSString *const VIDEO_TITLE_PATH = @"snippet.title";
NSString *const VIDEO_DESCRIPION_PATH = @"snippet.description";
NSString *const VIDEO_THUMBNAIL_PATH = @"snippet.thumbnails.high.url";

@interface VideoItemResult()

@property(nonatomic) BOOL selected;

@end

@implementation VideoItemResult

-(instancetype)initWithVideoId:(NSString *)videoId
                         title:(NSString *)title
                   description:(NSString *)description
               andThumbnailUrl:(NSString *)thumbnailUrl{
    if(self = [super init]) {
        self.youtubeId = videoId;
        self.title = title;
        self.videoDescription = description;
        self.thumbnailUrl = thumbnailUrl;
    }
    
    return self;
}

+(instancetype)videoWithVideoId:(NSString *)videoId title:(NSString *)title description:(NSString *)description andThumbnailUrl:(NSString *)thumbnailUrl{
    return [[self alloc] initWithVideoId:videoId title:title description:description andThumbnailUrl:thumbnailUrl];
}

+(instancetype)videoWithDict:(NSDictionary *)dict{
    VideoItemResult *video =
    [[self alloc] initWithVideoId:[dict valueForKeyPath:VIDEO_ID_PATH]
                            title:[dict valueForKeyPath:VIDEO_TITLE_PATH]
                      description:[dict valueForKeyPath:VIDEO_DESCRIPION_PATH]
                  andThumbnailUrl:[dict valueForKeyPath:VIDEO_THUMBNAIL_PATH]];
    
    return video;
}

-(NSString *)getVideoUrl{
    return [NSString stringWithFormat:[[[NSBundle mainBundle] infoDictionary]
                                       valueForKeyPath:@"AppConfig.YoutubeVideoUrlPattern"],
            self.youtubeId];
}

-(void)markAsSelected{
    _selected = YES;
}

-(void)unmarkAsSelected{
    _selected = NO;
}

@end
