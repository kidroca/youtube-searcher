//
//  PropertyExtractor.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyExtractor : NSObject

+ (NSArray *)extractPropertyNamesFrom:(NSObject *)object;

@end
