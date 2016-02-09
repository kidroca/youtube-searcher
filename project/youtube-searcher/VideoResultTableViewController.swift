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
    let reusableCellId = "VideoResultCell";
    let loadingCellId = "LoadingCell";
    let segueForVideoPlayerId = "segueForVideoPlayer";
    var alertController: UIAlertController!;
    
    var currentPage: PagedVideoCollectionResult;
    var loadedVideos: NSMutableArray;
    
    init(_ coder: NSCoder? = nil) {
        currentPage = PagedVideoCollectionResult();
        loadedVideos = NSMutableArray();
        
        if let coder = coder {
            super.init(coder: coder)!
        } else {
            super.init(nibName: nil, bundle:nil)
        }
    }
    
    public required convenience init(coder: NSCoder) {
        self.init(coder)
    }
    
    @IBAction func barButtonComposeTap(sender: AnyObject) {
        self.alertController = UIAlertController(title: "Save Playlist", message: "Enter a name for the playlist:", preferredStyle: UIAlertControllerStyle.ActionSheet);
        
        let textBox = UITextField();
        alertController.view.addSubview(textBox);
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            let selectedVideos = NSMutableArray();
            
            for(var i = 0; i < self.loadedVideos.count; i++) {
                let vid = self.loadedVideos[i] as! VideoItemResult;
                if vid.selected {
                    selectedVideos.addObject(vid);
                }
            }
            
            DataHandler.sharedHandler().savePlaylist(textBox.text, withVideos: selectedVideos as [AnyObject]);
            self.showPopup("Success", message: "Playlist \(textBox.text) saved sucesffull", interval: 3);
        }))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibReusableCell = UINib (nibName: reusableCellId, bundle: nil);
        self.tableView.registerNib(nibReusableCell, forCellReuseIdentifier: reusableCellId);
        
        let nibLoadingCell = UINib(nibName: loadingCellId, bundle: nil);
        self.tableView.registerNib(nibLoadingCell, forCellReuseIdentifier: loadingCellId);
        
        self.showPopup("Tip", message: "Click on the video title to save it in your playlist.", interval: 3);
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loadedVideos.count;
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < self.loadedVideos.count - 1 {
            return self.videoCell(indexPath);
        } else {
            return loadingCell();
        }
    }
    
    public override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell is LoadingCell {
            self.loadNextPage();
        }
    }
    
    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.loadedVideos.removeObjectAtIndex(indexPath.row);
            self.tableView.reloadData();
        }
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.segueForVideoPlayerId {
            let index = sender as! Int;
            let video = self.loadedVideos[index] as! VideoItemResult;
            let destVc = segue.destinationViewController as! VideoPlayerViewController;
            destVc.video = video;
        }
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.loadedVideos[indexPath.row].markAsSelected();
    }
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    self.loadedVideos[indexPath.row].unmarkAsSelected();
    }
    
    public func assignVideoCollection(collection: PagedVideoCollectionResult) {
        self.currentPage = collection;
        self.loadedVideos.addObjectsFromArray(collection.items as [AnyObject]);
        
        self.tableView.reloadData();
    }
    
    func btnOpenTap(sender: UIButton) {
        self.performSegueWithIdentifier(self.segueForVideoPlayerId, sender: sender.tag);
    }
    
    func btnDetailsTap(sender: UIButton) {
        let video = self.loadedVideos[sender.tag] as! VideoItemResult;
        self.showPopup(video.title, message: video.videoDescription, interval: 0);
    }
    
    func dismissAlert() {
        self.alertController.dismissViewControllerAnimated(true, completion: nil);
    }
    
    private func videoCell(indexPath: NSIndexPath) -> VideoResultCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reusableCellId) as! VideoResultCell
        cell.contentView.userInteractionEnabled = false;
        
        let video = loadedVideos[indexPath.row];
        let image = UIImage(data:
            NSData(contentsOfURL:
                NSURL(string: video.thumbnailUrl
                    )!)!)
        
        cell.lblTitle.text = video.title;
        cell.ivBackoundImage.image = image;
        
        cell.btnOpen.tag = indexPath.row;
        cell.btnDetails.tag = indexPath.row;
        cell.btnOpen.addTarget(self, action: "btnOpenTap:", forControlEvents: UIControlEvents.TouchUpInside);
        cell.btnDetails.addTarget(
            self, action: "btnDetailsTap:", forControlEvents: UIControlEvents.TouchUpInside);
        
        return cell;
    }
    
    private func loadingCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(loadingCellId) as! LoadingCell
        
        cell.progressIndicator.startAnimating();
        return cell;
    }
    
    private func loadNextPage() {
        let dataHandler = DataHandler.sharedHandler();
        
        dataHandler.getPageFor(self.currentPage.nextPageToken) { (Dictionary dict) -> Void in
            let page = PagedVideoCollectionResult.pagedCollectionWithDict(dict);
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.assignVideoCollection(page);
            })
        }
    }
    
    private func showPopup(title:String, message:String, interval: NSTimeInterval) {
        self.alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert);
        
        self.alertController.addAction(
            UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil));
        
        self.presentViewController(self.alertController, animated: true, completion: nil);
        
        if !interval.isZero {
            self.performSelector("dismissAlert", withObject: self, afterDelay: 2.5);
        }
    }
}