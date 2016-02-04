//
//  FirstViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *orderTypes = [NSArray arrayWithObjects:@"date", @"rating", @"relevance", @"title", @"viewCount", nil];
    self.ddmOrder.menuItems = orderTypes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
