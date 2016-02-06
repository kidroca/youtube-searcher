//
//  PropertyExtractor.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "PropertyExtractor.h"
#import <objc/runtime.h>

@implementation PropertyExtractor

+ (NSArray *)extractPropertyNamesFrom:(NSObject *)object{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
    
    NSMutableArray * propertyNames = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    
    NSLog(@"Property names: %@", propertyNames);
    
    return propertyNames;
}

@end
