//
//  VideoItemResult.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoItemResult : NSObject

@property(strong, nonatomic) NSString *videoId;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *videoDescription;
@property(strong, nonatomic) NSString *thumbnailUrl;

@end