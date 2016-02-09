//
//  VideoMO.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/9/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoMO : NSObject

@property(strong, nonatomic) NSString *youtubeId;

@property(strong, nonatomic) NSString *videoDescription;

@property(strong, nonatomic) NSString *title;

@property(strong, nonatomic) NSData* thumbnailData;

-(NSString* )getVideoUrl;

@end
