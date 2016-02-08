//
//  Playlist.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/8/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "Playlist.h"

@implementation Playlist

- (instancetype)initWith:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        self.videos = [NSMutableArray array];
    }

    return self;
}

@end
