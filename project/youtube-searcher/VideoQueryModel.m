//
//  VideoQueryModel.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "VideoQueryModel.h"
#import "PropertyExtractor.h"

@interface VideoQueryModel()

@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@property(strong, nonatomic) NSString *queryString;

@end

@implementation VideoQueryModel

- (instancetype) init{
    if (self = [super init]) {
        NSString *dateFormat = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"AppConfig.DateFormat"];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:dateFormat];
        
        // Register an observer for property changes so the query string is
        // not rebuilt each time, but only if some property changed
        NSArray *myProperties = [PropertyExtractor extractPropertyNamesFrom:self];
        for (NSString *prop in myProperties) {
            [self addObserver:self forKeyPath:prop options:0 context:nil];
        }
    }
    
    return self;
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // Brute reset of the query string
    if ([keyPath isEqualToString:@"queryString"]) {
        return;
    }
    
    self.queryString = nil;
}

- (NSString *)getQueryString{
    if (!self.queryString) {
        NSMutableString *stringBuilder = [[NSMutableString alloc] initWithString:@"?part=snippet"];
        
        [stringBuilder appendFormat:@"&q=%@", self.searchTearm];
        
        if (self.publishedAfter) {
            NSString *afterDate = [self.dateFormatter stringFromDate:self.publishedAfter];
            [stringBuilder appendFormat:@"&publishedAfter=%@", afterDate];
        }
        
        if (self.publishedBefore) {
            NSString *beforeDate = [self.dateFormatter stringFromDate:self.publishedBefore];
            [stringBuilder appendFormat:@"&publishedBefore=%@", beforeDate];
        }
        
        if (self.highDefinition) {
            [stringBuilder appendFormat:@"&videoDefinition=high"];
        }
        
        if (self.maxVideosCount) {
            [stringBuilder appendFormat:@"&maxResults=%ld", self.maxVideosCount];
        }
        
        if (self.sortOrder) {
            [stringBuilder appendFormat:@"&order=%@", self.sortOrder];
        }
        
        self.queryString = stringBuilder;
    }
    
    return self.queryString;
}

@end
