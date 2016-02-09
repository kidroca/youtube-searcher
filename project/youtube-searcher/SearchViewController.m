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
#import "youtube_searcher-Swift.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnReady;

@property (weak, nonatomic) IBOutlet UITextField *tfSearchTerm;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedAfter;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedBefore;
@property (weak, nonatomic) IBOutlet UISwitch *swichHiDef;
@property (weak, nonatomic) IBOutlet DropDownMenu *ddSortOrder;

@property (strong, nonatomic) VideoQueryModel *queryModel;

@property(nonatomic) BOOL isUserInterestedInMinimumDateRestriction;
@property(nonatomic) BOOL isUserInterestedInMaximumDateRestriction;

@end

@implementation SearchViewController

static NSString *videoResultControllerId = @"videoResultControllerId";
static NSString *segueToVideoResultsId = @"segueToVideoResults";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Search Videos"];
    
    self.queryModel = [[VideoQueryModel alloc] init];
    
    [self uiConfig];
    NSArray *orderTypes = [[DataHandler sharedHandler] getResultOrders];
    self.ddSortOrder.menuItems = orderTypes;
}

-(void) uiConfig{
    UIColor *textColor = self.lblSearch.textColor;
    UIColor *bgColor = self.btnReady.backgroundColor;
    //    UIFont *font = self.lblSearch.font;
    
    [self.dpPublishedAfter setValue:textColor forKey:@"textColor"];
    [self.dpPublishedBefore setValue:textColor forKey:@"textColor"];
    
    // Bug not yet resolved in Interface Builder not applying background color
    [self.dpPublishedAfter setBackgroundColor:bgColor];
    [self.dpPublishedBefore setBackgroundColor:bgColor];
}

- (IBAction)onDpPublishedAfterValueChanged:(UIDatePicker *)sender {
    [self.dpPublishedBefore setMinimumDate:sender.date];
    self.isUserInterestedInMinimumDateRestriction = YES;
}
- (IBAction)onDpPublishedBeforeValueChanged:(UIDatePicker *)sender {
    [self.dpPublishedAfter setMaximumDate:sender.date];
    self.isUserInterestedInMaximumDateRestriction = YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:segueToVideoResultsId]) {
        [self fillQueryInformation];
        
        __weak VideoResultTableViewController *toVC = segue.destinationViewController;
        
        [[DataHandler sharedHandler] searchFor:self.queryModel
                                   withHandler:^(NSDictionary * _Nullable dict) {
                                       
                                       PagedVideoCollectionResult *videos =
                                       [PagedVideoCollectionResult pagedCollectionWithDict:dict];
                                       NSLog(@"%@", videos);
                                       
                                       // Execute from the Main thread
                                   	    dispatch_async(dispatch_get_main_queue(), ^{
                                           [toVC assignVideoCollection:videos];
                                       });
                                   }];
    }
}

- (void) fillQueryInformation{
    if(![self.queryModel.q isEqualToString: self.tfSearchTerm.text]){
        self.queryModel.q = self.tfSearchTerm.text;
    }
    
    if (self.isUserInterestedInMinimumDateRestriction &&
        ![self.queryModel.publishedAfter isEqualToDate: self.dpPublishedAfter.date]){
        self.queryModel.publishedAfter = self.dpPublishedAfter.date;
    }
    
    if (self.isUserInterestedInMaximumDateRestriction &&
        ![self.queryModel.publishedBefore isEqualToDate: self.dpPublishedBefore.date]){
        self.queryModel.publishedBefore = self.dpPublishedBefore.date;
    }
    
    if (self.queryModel.highDefinition != self.swichHiDef.selected) {
        self.queryModel.highDefinition = self.swichHiDef.selected;
    }
    
    if (self.ddSortOrder.getSelectedItem &&
        ![self.queryModel.order isEqualToString:self.ddSortOrder.getSelectedItem]) {
        self.queryModel.order = self.ddSortOrder.getSelectedItem;
    }
}

@end
