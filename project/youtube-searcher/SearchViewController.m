//
//  FirstViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "SearchViewController.h"
#import "DataHandler.h"
#import "PagedVideoCollection_HttpExtensions.h"
#import "VideoResultTableViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfSearchTerm;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedAfter;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedBefore;
@property (weak, nonatomic) IBOutlet UISwitch *swichHiDef;
@property (weak, nonatomic) IBOutlet DropDownMenu *ddSortOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblVideosCount;

@property (strong, nonatomic) VideoQueryModel *queryModel;

@end

@implementation SearchViewController

static NSString *videoResultControllerId = @"videoResultControllerId";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Search Videos"];
    
    self.queryModel = [[VideoQueryModel alloc] init];
    
    NSArray *orderTypes = [NSArray arrayWithObjects:@"date", @"rating", @"relevance", @"title", @"viewCount", nil];
    self.ddSortOrder.menuItems = orderTypes;
}

- (IBAction)onBtnReadyTap:(id)sender {
    [self fillQueryInformation];

    VideoResultTableViewController *resultsVC =
    [self.storyboard instantiateViewControllerWithIdentifier:videoResultControllerId];
    
    [[DataHandler sharedHandler] searchFor:self.queryModel
                               withHandler:^(NSDictionary * _Nullable dict) {
                                   
                                   PagedVideoCollectionResult *videos =
                                   [PagedVideoCollectionResult pagedCollectionWithDict:dict];
                                   NSLog(@"%@", videos);
                                   
                                   resultsVC.videoCollection = videos;
                                   [resultsVC.tableView reloadData];
                               }];
    
    [self.navigationController pushViewController:resultsVC animated:YES];
}

- (void) fillQueryInformation{
    if(![self.queryModel.q isEqualToString: self.tfSearchTerm.text]){
        self.queryModel.q = self.tfSearchTerm.text;
    }
    
    if (![self.queryModel.publishedAfter isEqualToDate: self.dpPublishedAfter.date]){
        self.queryModel.publishedAfter = self.dpPublishedAfter.date;
    }
    
    if (![self.queryModel.publishedBefore isEqualToDate: self.dpPublishedBefore.date]){
        self.queryModel.publishedBefore = self.dpPublishedBefore.date;
    }
    
    if (self.queryModel.highDefinition != self.swichHiDef.selected) {
        self.queryModel.highDefinition = self.swichHiDef.selected;
    }
    
    if (self.ddSortOrder.getSelectedItem &&
        ![self.queryModel.order isEqualToString:self.ddSortOrder.getSelectedItem]) {
        self.queryModel.order = self.ddSortOrder.getSelectedItem;
    }
    
    if (self.queryModel.maxResults != self.stepperVideosCount.value) {
        self.queryModel.maxResults = self.stepperVideosCount.value;
    }
}

@end
