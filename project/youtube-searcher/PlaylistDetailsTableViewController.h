//
//  PlaylistDetailsTableViewController.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/10/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewController.h"

@interface PlaylistDetailsTableViewController : CommonTableViewController

@property(strong, nonatomic) PlaylistMO *playlist;

@end
