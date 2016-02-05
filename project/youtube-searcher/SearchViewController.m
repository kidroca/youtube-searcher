//
//  FirstViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfSearchTerm;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedAfter;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpPublishedBefore;
@property (weak, nonatomic) IBOutlet UISwitch *swichHiDef;
@property (weak, nonatomic) IBOutlet UITextField *tfMaxVideosCount;
@property (weak, nonatomic) IBOutlet DropDownMenu *ddSortOrder;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *orderTypes = [NSArray arrayWithObjects:@"date", @"rating", @"relevance", @"title", @"viewCount", nil];
    self.ddSortOrder.menuItems = orderTypes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
