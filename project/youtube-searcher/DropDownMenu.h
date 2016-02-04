//
//  DropDownMenu.h
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSArray *menuItems;

@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property (weak, nonatomic) IBOutlet UITableView *tvMenuTable;

- (instancetype) initWithFrame:(CGRect)frame andMenuItems:(NSArray *)items;

//- (id) getSelectedItem;

+ (instancetype) dropDownMenuWithFrame:(CGRect)frame andMenuItems:(NSArray *)items;

@end