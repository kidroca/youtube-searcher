//
//  Playlist.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/8/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Playlist : NSObject

@property(strong, nonatomic) NSString *name;

@property(strong, nonatomic) NSMutableArray *videos;

@end
