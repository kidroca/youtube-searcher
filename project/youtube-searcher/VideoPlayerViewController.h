//
//  VideoPlayerViewController.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/8/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import "VideoItemResult.h"

@interface VideoPlayerViewController : UIViewController

@property(strong, nonatomic) VideoItemResult *video;

@end
