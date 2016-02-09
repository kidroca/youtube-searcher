//
//  VideoMO.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/9/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "VideoMO.h"

@implementation VideoMO

@dynamic youtubeId;
@dynamic videoDescription;
@dynamic title;
@dynamic thumbnailData;

-(NSString *)getVideoUrl{
    return [NSString stringWithFormat:[[[NSBundle mainBundle] infoDictionary]
                                       valueForKeyPath:@"AppConfig.YoutubeVideoUrlPattern"],
            self.youtubeId];
}

@end
