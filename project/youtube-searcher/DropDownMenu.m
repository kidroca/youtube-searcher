//
//  DropDownMenu.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/4/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "DropDownMenu.h"

NSString *const REUSABLE_CELL_ID = @"reusableDropDownCell";

@interface DropDownMenu()

@property(strong, nonatomic) UIView *viewWrapper;
@property(strong, nonatomic) NSMutableArray *customConstraints;
@property(strong, nonatomic) id selectedItem;

@end

@implementation DropDownMenu

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self && self.subviews.count == 0) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andMenuItems:(NSArray *)items{
    self = [self initWithFrame:frame];
    if (self){
        self.menuItems = items;
    }
    
    return self;
}

- (void)commonInit{
    _customConstraints = [[NSMutableArray alloc] init];
    
    // Register a reusable cell...
    [self.tvMenuTable registerClass:[UITableViewCell class] forCellReuseIdentifier:REUSABLE_CELL_ID];
    
    UIView *view = nil;
    NSArray *nibs = [[NSBundle mainBundle]
                    loadNibNamed:NSStringFromClass([self class])
                    owner:self
                    options:nil];
    
    for (id nib in nibs) {
        if ([nib isKindOfClass:[UIView class]]) {
            view = nib;
            break;
        }
    }
    
    if(view) {
        _viewWrapper = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

- (void) updateConstraints{
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    
    if (self.viewWrapper) {
        UIView *view = self.viewWrapper;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        [self.customConstraints addObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:
           @"H:|[view]|" options:0 metrics:nil views:views]];
         [self.customConstraints addObjectsFromArray:
          [NSLayoutConstraint constraintsWithVisualFormat:
           @"V:|[view]|" options:0 metrics:nil views:views]];
         
         [self addConstraints:self.customConstraints];
    }
    
    [super updateConstraints];
}

+ (instancetype)dropDownMenuWithFrame:(CGRect)frame andMenuItems:(NSArray *)items{
    return [[DropDownMenu alloc] initWithFrame:frame andMenuItems:items];
}

- (void)setMenuItems:(NSArray *)value{
    if (!value || value.count < 1) {
        NSException *ex = [NSException exceptionWithName:@"Invalid Menu Data" reason:@"The received array with menu items is empty or null" userInfo:nil];
        
        [ex raise];
    }
    
    _menuItems = value;
    [self.tvMenuTable reloadData];
}

- (id) getSelectedItem{
    return self.selectedItem;
}

- (IBAction)onSelectButtonTap:(UIButton *)sender {
    [self toggleMenuVisibility];
}

- (void)toggleMenuVisibility{
    if(self.tvMenuTable.hidden) {
        self.tvMenuTable.hidden = NO;
    } else {
        self.tvMenuTable.hidden = YES;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSABLE_CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSABLE_CELL_ID];
    }
    
    id menuItem = [self.menuItems objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[menuItem description]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedItem = [self.menuItems objectAtIndex:indexPath.row];
    self.tvMenuTable.hidden = YES;
    [self.btnSelect setTitle:[self.selectedItem description] forState:UIControlStateNormal];
}

@end
