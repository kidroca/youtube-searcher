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
    var loadedVideos: Array<VideoItemResult>;
    
    init(_ coder: NSCoder? = nil) {
        currentPage = PagedVideoCollectionResult();
        loadedVideos = Array();
        
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
        alertController = UIAlertController(title: "Save Playlist", message: "Enter a name for the playlist:", preferredStyle: UIAlertControllerStyle.Alert);
        
        alertController.addAction(UIAlertAction(
            title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil));
        
        alertController.addTextFieldWithConfigurationHandler(nil);
        
        alertController.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            self.savePlaylist();
        }))
        
        self.presentViewController(self.alertController, animated: true, completion: nil);
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
    
    // No reason to support deleting for now
//    public override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            self.loadedVideos.removeAtIndex(indexPath.row);
//            self.tableView.reloadData();
//        }
//    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.segueForVideoPlayerId {
            let index = sender as! Int;
            let video = self.loadedVideos[index];
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
        let videos = collection.items as! Array<VideoItemResult>;
        self.loadedVideos.appendContentsOf(videos);
        
        self.tableView.reloadData();
    }
    
    func btnOpenTap(sender: UIButton) {
        self.performSegueWithIdentifier(self.segueForVideoPlayerId, sender: sender.tag);
    }
    
    func btnDetailsTap(sender: UIButton) {
        let video = self.loadedVideos[sender.tag];
        self.showPopup(video.title, message: video.videoDescription, interval: 0);
    }
    
    func dismissAlert() {
        self.alertController.dismissViewControllerAnimated(true, completion: nil);
    }
    
    private func videoCell(indexPath: NSIndexPath) -> VideoResultCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reusableCellId) as! VideoResultCell
        cell.contentView.userInteractionEnabled = false;
        
        let video = loadedVideos[indexPath.row];
        if video.thumbnailData == nil {
            let imageData = NSData(contentsOfURL:
                NSURL(string: video.thumbnailUrl)!);
            video.thumbnailData = imageData;
        }
        
        cell.lblTitle.text = video.title;
        cell.ivBackoundImage.image = UIImage(data: video.thumbnailData);
        
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
            self.performSelector("dismissAlert", withObject: self, afterDelay: interval);
        }
    }
    
    private func savePlaylist(){
        let textField = self.alertController.textFields?.first;
        if textField == nil || textField?.text?.isEmpty == true {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showPopup(
                    "Error", message: "Enter a playlist name", interval: 0);
            });

            return;
        }
        
        var selectedVideos = Array<VideoItemResult>();
        
        for(var i = 0; i < self.loadedVideos.count; i++) {
            let vid = self.loadedVideos[i];
            if vid.selected {
                selectedVideos.append(vid);
            }
        }
        
        if selectedVideos.count == 0 {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.showPopup(
                    "Error", message: "Select some videos to add", interval: 0);
            });
            
            return;
        }
        
        DataHandler.sharedHandler().createPlaylistWithName(
            textField!.text!, andVideos: selectedVideos);
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let name = textField!.text!;
            self.showPopup(
                "Success", message: "Playlist \(name) saved sucesffull", interval: 0);
        });
    }
    
}