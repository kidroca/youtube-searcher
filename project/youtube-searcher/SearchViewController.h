//
//  FirstViewController.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenu.h"

@interface SearchViewController : UIViewController

@property (weak, nonatomic) IBOutlet DropDownMenu *ddmOrder;

@end

