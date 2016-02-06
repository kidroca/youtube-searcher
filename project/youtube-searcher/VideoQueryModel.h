//
//  VideoQueryModel.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoQueryModel : NSObject

@property(strong, nonatomic) NSString *searchTearm;

@property(strong, nonatomic) NSDate *publishedAfter;

@property(strong, nonatomic) NSDate *publishedBefore;

@property(nonatomic) BOOL highDefinition;

@property(nonatomic) NSInteger maxVideosCount;

@property(strong, nonatomic) NSString *sortOrder;

- (NSString *) getQueryString;

@end
