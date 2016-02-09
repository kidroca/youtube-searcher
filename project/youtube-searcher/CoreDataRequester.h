//
//  CoreDataRequester.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/9/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol SearcherCoreDataRequester <NSObject>

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

-(NSManagedObject *	)createInstanceOfEntity:(NSString *) entityName;

- (NSArray *) getAllEntities:(NSString *)entityName
                    skipping:(NSInteger)skip
                   andTaking:(NSInteger)take;

-(NSArray *) getAllEntities:(NSString *)entityName;

-(NSArray *) findEntity:(NSString* )entityName
              withValue:(NSString *)value
                 forKey:(NSString *) key;

-(void) saveChanges;

@end

@interface CoreDataRequester : NSObject<SearcherCoreDataRequester>

- (void)initializeCoreData;

@end
