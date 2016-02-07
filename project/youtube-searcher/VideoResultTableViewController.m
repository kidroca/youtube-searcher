//
//  VideoResultTableViewController.m
//  youtube-searcher
//
//  Created by Peter Velkov on 2/6/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

#import "VideoResultTableViewController.h"

@implementation VideoResultTableViewController

-(void)viewDidLoad{
    self.title = @"Results";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoCollection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableCellId= @"reusableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellId
                                                            forIndexPath:indexPath];
    // Note to self reusableCellId was defined as REUSABLE_CELL_ID which in turn was
    // refereing to the constant with the same name declared in DropDownMenu class... why?
    
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reusableCellId];
    }
    
    VideoItemResult *video = [self.videoCollection.items objectAtIndex:indexPath.row];
    [cell.textLabel setText:video.title];
    [cell.imageView setImage:
     [UIImage imageWithData:
      [NSData dataWithContentsOfURL:
       [NSURL URLWithString:video.thumbnailUrl]]]]; // LOL...
    
//    if (!cell.imageView.image) {
//        [cell.imageView setImage: [UIImage imageNamed:DEFAULT_IMAGE_NAME]];
//    }
    
    return cell;
}

@end
