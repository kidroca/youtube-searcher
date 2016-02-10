//
//  PlaylistMO+CoreDataProperties.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/10/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlaylistMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaylistMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<VideoMO *> *videos;

@end

@interface PlaylistMO (CoreDataGeneratedAccessors)

- (void)addVideosObject:(VideoMO *)value;
- (void)removeVideosObject:(VideoMO *)value;
- (void)addVideos:(NSSet<VideoMO *> *)values;
- (void)removeVideos:(NSSet<VideoMO *> *)values;

@end

NS_ASSUME_NONNULL_END
