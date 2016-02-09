//
//  CoreDataRequester.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/9/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "CoreDataRequester.h"

NSString *const ERROR_MESSAGE_FORMAT = @"Error fetching from the database \n Error: %@";

@implementation CoreDataRequester

@synthesize managedObjectContext;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    [self initializeCoreData];
    
    return self;
}

-(void)initializeCoreData{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"youtube-searcher" withExtension:@"momd"];
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [moc setPersistentStoreCoordinator:psc];
    managedObjectContext = moc;
    
     NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"youtube-searcher.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

-(NSManagedObject *	)createInstanceOfEntity:(NSString *) entityName{
    
    NSManagedObject *newInstance =
    [NSEntityDescription insertNewObjectForEntityForName:entityName
                                  inManagedObjectContext:self.managedObjectContext];
    
    return newInstance;
}

- (NSArray *) getAllEntities:(NSString *)entityName
                    skipping:(NSInteger)skip
                   andTaking:(NSInteger)take{
    
    NSFetchRequest *fetech = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetech.fetchOffset = skip;
    fetech.fetchLimit = take;
    
    NSError *err = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetech error:&err];
    
    if(fetchedObjects == nil){
        NSLog(ERROR_MESSAGE_FORMAT, err);
        return @[];
    }
    
    return fetchedObjects;
}

-(NSArray *) getAllEntities:(NSString *)entityName{
    return [self getAllEntities:entityName skipping:0 andTaking:NSIntegerMax];
}

-(NSArray *) findEntity:(NSString* )entityName
              withValue:(NSString *)value
                 forKey:(NSString *) key{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
    [fetchRequest setPredicate:predicate];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(ERROR_MESSAGE_FORMAT, error);
        return @[];
    }
    
    return fetchedObjects;
}

-(void)saveChanges{
    NSError *error = nil;
    if ([[self managedObjectContext] save:&error] == NO) {
        NSLog(ERROR_MESSAGE_FORMAT, error);
    }
}

@end
