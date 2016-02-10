//
//  PlaylistDetailsTableViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/10/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "PlaylistDetailsTableViewController.h"
#import "youtube_searcher-Swift.h"
#import "VideoPlayerViewController.h"
#import "DataHandler.h"

@interface PlaylistDetailsTableViewController()<NSFetchedResultsControllerDelegate>

@end

@implementation PlaylistDetailsTableViewController

static NSString *reusableCellId = @"VideoResultCell";
static NSString *segueForVideoPlayer = @"segueForVideoPlayer";

-(NSString *)reusableCellId{
    return reusableCellId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *nibReusableCell = [UINib nibWithNibName:reusableCellId bundle:nil];
    [self.tableView registerNib:nibReusableCell forCellReuseIdentifier:reusableCellId];
    
    [self initializeFetchedResultsController];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:segueForVideoPlayer]) {
        VideoPlayerViewController *toVC = segue.destinationViewController;
        toVC.video = sender;
    }
}


- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:VIDEO_ENTITY_KEY];
    
    NSSortDescriptor *title = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];

    NSPredicate *requestPredicate =[NSPredicate predicateWithFormat:@"(playlist = %@)",
                                    self.playlist];
    
    [request setPredicate:requestPredicate];
    
    [request setSortDescriptors:@[title]];

    NSManagedObjectContext *moc = [[[DataHandler sharedHandler] coreDataRequester]
                                   managedObjectContext];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    
    __weak  PlaylistDetailsTableViewController * _Nullable weakSelf = self;
    [[self fetchedResultsController] setDelegate:weakSelf];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }	
}

- (void)configureCell:(VideoResultCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    VideoMO *video = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = false;
    
    if (!video.thumbnailData) {
        NSData *imageData = [NSData dataWithContentsOfURL:
                             [NSURL URLWithString:video.thumbnailUrl]];

        video.thumbnailData = imageData;
    }
    
    cell.lblTitle.text = video.title;
    cell.ivBackoundImage.image = [UIImage imageWithData:video.thumbnailData];
    
    cell.attachedObject = video;
    cell.tag = indexPath.row;
    cell.tag = indexPath.row;
    cell.btnOpen.tag = indexPath.row;
    cell.btnDetails.tag = indexPath.row;
    
    [cell.btnOpen addTarget:self action:@selector(btnOpenTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.btnDetails addTarget:self action:@selector(btnDetailsTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) btnOpenTap:(UIButton *) sender {
    VideoResultCell *videoCell = (VideoResultCell *) [self findSuperViewOfClass:[VideoResultCell class] forView:sender];
    
    [self performSegueWithIdentifier:segueForVideoPlayer
                              sender:videoCell.attachedObject];
}

-(void) btnDetailsTap: (UIButton *) sender {
    VideoResultCell *videoCell = (VideoResultCell *) [self findSuperViewOfClass:[VideoResultCell class] forView:sender];
    VideoMO *video = videoCell.attachedObject;
    
    [self showPopUpWithTitle:video.title andMessage:video.videoDescription];
}

-(id) findSuperViewOfClass:(Class)class forView:(UIView *) view {
    UIView *v = view.superview;
    while (![v isMemberOfClass:class]) {
        if(v.superview) {
            v = v.superview;
        } else {
            return nil;
        }
    }
    
    return v;
}

-(void) showPopUpWithTitle:(NSString *)title andMessage:(NSString *) message{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
    ac.view.center = self.view.center;
}

@end
