//
//  VideoResultTableViewController.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedVideoCollection_HttpExtensions.h"
#import "DataHandler.h"

@interface VideoResultTableViewController : UITableViewController

@property(strong, nonatomic) PagedVideoCollectionResult *videoCollection;

@end
