	//
//  SavedPlaylistsTableViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/9/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "SavedPlaylistsTableViewController.h"
#import "PlaylistDetailsTableViewController.h"

@interface SavedPlaylistsTableViewController()<NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *noPlaylistsView;

@property (strong, nonatomic) PlaylistMO *playlistForDetailsView;

@end

@implementation SavedPlaylistsTableViewController

static NSString *reusableCellId = @"reusablePlaylistCell";
static NSString *detailsSegueId = @"showDetailSegue";

-(NSString *)reusableCellId{
    return reusableCellId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Your Playlists";
    
    [self initializeFetchedResultsController];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showNoPlaylistsViewIfNecessary];
}

-(void)showNoPlaylistsViewIfNecessary{
    if (![self.tableView numberOfRowsInSection:0]) {
        [self.view addSubview:self.noPlaylistsView];
        
        self.noPlaylistsView.center = self.view.center;
        [self.view bringSubviewToFront:self.noPlaylistsView];
        self.noPlaylistsView.hidden = NO;
    } else {
        self.noPlaylistsView.hidden = YES;
    }
}

- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:PLAYLIST_ENTITY_KEY];
    
    NSSortDescriptor *name = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[name]];
    [request setRelationshipKeyPathsForPrefetching:@[@"video"]];
    
    NSManagedObjectContext *moc = [[[DataHandler sharedHandler] coreDataRequester]
                                   managedObjectContext];
    
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    
    __weak  SavedPlaylistsTableViewController * _Nullable weakSelf = self;
    [[self fetchedResultsController] setDelegate:weakSelf];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    PlaylistMO *playlist = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [cell.textLabel setText:playlist.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%lu Videos",
                                   (unsigned long)playlist.videos.count]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView
  commitEditingStyle:editingStyle
   forRowAtIndexPath:indexPath];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showNoPlaylistsViewIfNecessary];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:detailsSegueId]) {
        PlaylistDetailsTableViewController *toVc = segue.destinationViewController;
        
        toVc.playlist = self.playlistForDetailsView;
    }
}

- (IBAction)onBtnAddPlaylistTap:(id)sender {
    [self.tabBarController setSelectedIndex:0];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.playlistForDetailsView = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:detailsSegueId sender:nil];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.playlistForDetailsView = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:detailsSegueId sender:nil];
}

@end
