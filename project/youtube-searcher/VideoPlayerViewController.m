//
//  VideoPlayerViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/8/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.video){
        [self.playerView loadWithVideoId:self.video.youtubeId];
    }
}

@end
