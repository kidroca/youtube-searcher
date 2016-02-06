//
//  VideoQueryModel.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoQueryModel : NSObject

@property(strong, nonatomic) NSString *q;

@property(strong, nonatomic) NSDate *publishedAfter;

@property(strong, nonatomic) NSDate *publishedBefore;

@property(nonatomic) BOOL highDefinition;

@property(nonatomic) NSInteger maxResults;

@property(strong, nonatomic) NSString *order;

- (NSMutableArray<NSURLQueryItem*> *) getQueryItems;

@end
