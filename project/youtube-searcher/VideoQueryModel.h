//
//  VideoQueryModel.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoQueryModel : NSObject

@property(strong, nonatomic, readonly) NSString *searchTearm;

@property(strong, nonatomic, readonly) NSDate *publishedAfter;

@property(strong, nonatomic, readonly) NSDate *publishedBefore;

@property(nonatomic, readonly) BOOL highDefinition;

@property(nonatomic, readonly) NSInteger maxVideosCount;

@property(strong, nonatomic, readonly) NSString *sortOrder;

- (NSString *) getQueryString;

@end
