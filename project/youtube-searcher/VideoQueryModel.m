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

// replace with dictionary if time...
@property(strong, nonatomic) NSMutableArray<NSURLQueryItem *> *queryItems;

@end

@implementation VideoQueryModel

static NSString *VIDEO_DEFINITION_QUERY_KEY = @"videoDefinition";

- (instancetype) init{
    if (self = [super init]) {
        
        [self configDateFormat];
        [self configQueryItems];
        [self registerObservers];
    }
    
    return self;
}

-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context{
    
    NSURLQueryItem *qItem = nil;
    
    // Special Case
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(highDefinition))]) {
        NSString *newValue = nil;
        if ((BOOL)[change objectForKey:NSKeyValueChangeNewKey]) {
            newValue = @"high";
        } else {
            newValue = @"any";
        }
        
        qItem = [[NSURLQueryItem alloc] initWithName:VIDEO_DEFINITION_QUERY_KEY value:newValue];
        NSInteger index = [self indexOfQueryItemWithKey:VIDEO_DEFINITION_QUERY_KEY];
        
        self.queryItems[index] = qItem;
        return;
    }
    
    // Common Case
    id newValue = [change objectForKey:NSKeyValueChangeNewKey];
    NSString *stringValue = nil;
    
    if ([newValue isKindOfClass:[NSDate class]]) {
        stringValue = [self.dateFormatter stringFromDate:newValue];
    } else {
        stringValue = newValue;
    }
    
    qItem = [[NSURLQueryItem alloc] initWithName:keyPath value:stringValue];
    
    NSInteger index = [self indexOfQueryItemWithKey:keyPath];
    if (index > -1) {
        [self.queryItems removeObjectAtIndex:index];
    }
    
    [self.queryItems addObject:qItem];
}

- (NSArray<NSURLQueryItem *> *)getQueryItems{
    return self.queryItems;
}

- (NSInteger) indexOfQueryItemWithKey:(NSString *)key {
    for (NSInteger i = 0; i < self.queryItems.count; i++) {
        if ([self.queryItems[i].name isEqualToString:key]) {
            return i;
        }
    }
    
    return -1;
}

- (void) configDateFormat{
    NSString *dateFormat = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"AppConfig.DateFormat"];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:dateFormat];
}

-(void) configQueryItems{
    self.queryItems = [[NSMutableArray alloc] init];
    
    // Add required query parameters
    NSURLQueryItem *part = [NSURLQueryItem queryItemWithName:@"part" value:@"snippet"];
    NSURLQueryItem *type = [NSURLQueryItem queryItemWithName:@"type" value:@"video"];
    // Restriction to only include data fields of interest and reduce traffic
    NSURLQueryItem *fields =
    [NSURLQueryItem queryItemWithName:@"fields"
                                value:@"items(id%2Csnippet)%2CnextPageToken%2CprevPageToken"];
    
    [self.queryItems addObject:part];
    [self.queryItems addObject:type];
    [self.queryItems addObject:fields];
}

-(void) registerObservers{
    // Register an observer for all model property changes so the query string is
    // not rebuilt each time, but only the properties that changed
    NSArray *myProperties = [PropertyExtractor extractPropertyNamesFrom:self];
    for (NSString *prop in myProperties) {
        [self addObserver:self forKeyPath:prop options:NSKeyValueObservingOptionNew context:nil];
    }
    // Unregister from the queryItems because it will be changed each time our properties are changed
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(queryItems))];
    
    // Unregister from the dateFormater as it's value is not of interest
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(dateFormatter))];
}

@end
