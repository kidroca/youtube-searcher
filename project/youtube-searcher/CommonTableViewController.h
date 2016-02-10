//
//  CommonTableViewController.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/10/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataHandler.h"

@interface CommonTableViewController :
UITableViewController<NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController *fetchedResultsController;

@property NSString *reusableCellId;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)initializeFetchedResultsController;

@end
