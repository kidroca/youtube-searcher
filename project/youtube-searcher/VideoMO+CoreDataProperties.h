//
//  VideoMO+CoreDataProperties.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/10/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "VideoMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *thumbnailData;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *videoDescription;
@property (nullable, nonatomic, retain) NSString *youtubeId;
@property (nullable, nonatomic, retain) NSString *thumbnailUrl;
@property (nullable, nonatomic, retain) PlaylistMO *playlist;

@end

NS_ASSUME_NONNULL_END
