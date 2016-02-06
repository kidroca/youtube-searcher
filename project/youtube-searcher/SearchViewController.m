//
//  FirstViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "SearchViewController.h"
#import "HttpRequester.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfSearchTerm;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedAfter;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedBefore;
@property (weak, nonatomic) IBOutlet UISwitch *swichHiDef;
@property (weak, nonatomic) IBOutlet DropDownMenu *ddSortOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblVideosCount;
@property (weak, nonatomic) IBOutlet UIStepper *stepperVideosCount;

@property (strong, nonatomic) VideoQueryModel *queryModel;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.queryModel = [[VideoQueryModel alloc] init];
    
    NSArray *orderTypes = [NSArray arrayWithObjects:@"date", @"rating", @"relevance", @"title", @"viewCount", nil];
    self.ddSortOrder.menuItems = orderTypes;
}

- (IBAction)onStepperValueChange:(UIStepper *)stepper {
    NSInteger val = stepper.value;
    if(val > 0) {
        [self.lblVideosCount setText:[NSString stringWithFormat:@"%ld", val]];
    } else {
        [self.lblVideosCount setText:@"max"];
    }
}

- (IBAction)onBtnReadyTap:(id)sender {
    [self fillQueryInformation];
    NSMutableArray *queryItems = [self.queryModel getQueryItems];
    
    NSString *key = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"AppConfig.ApiCredentialsKey"];
    NSString *urlString = [[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"AppConfig.YoutubeApiUrl"];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"key" value:key]];
    
    HttpRequester *req = [[HttpRequester alloc] init];
//    HttpRequester *req = [HttpRequester httpRequesterWithBaseUrl:urlString];
    [req setQueryStringWith:queryItems];
    [req httpGetFrom:urlString];
    // Go to result view
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
