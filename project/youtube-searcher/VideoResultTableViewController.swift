//
//  VideoResultTableViewController.swift
//  youtube-searcher
//
//  Created by Peter Velkov on 2/7/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

import Foundation
import UIKit

public class VideoResultTableViewController: UITableViewController	{
    
    let reusableCellId: String
    
    var videoCollection: PagedVideoCollectionResult
    
    init(_ coder: NSCoder? = nil) {
        reusableCellId = "VideoResultCell";
        videoCollection = PagedVideoCollectionResult();
        
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    required convenience public init(coder: NSCoder) {
        self.init(coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib (nibName: reusableCellId, bundle: nil);
        self.tableView.registerNib(nib, forCellReuseIdentifier: reusableCellId);
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videoCollection.items.count;
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reusableCellId) as! VideoResultCell
        cell.contentView.userInteractionEnabled = false;
        
        let video = self.videoCollection.items[indexPath.row];
        let image = UIImage(data:
            NSData(contentsOfURL:
                NSURL(string: video.thumbnailUrl
                    )!)!)
        
        cell.lblTitle.text = video.title;
        cell.ivBackoundImage.image = image;
        
        return cell;
    }
    
    public func assignVideoCollection(collection: PagedVideoCollectionResult) {
        self.videoCollection = collection;
        self.tableView.reloadData();
    }
}