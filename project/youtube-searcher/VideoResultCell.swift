//
//  VideoResultCell.swift
//  youtube-searcher
//
//  Created by Peter Velkov on 2/7/16.
//  Copyright © 2016 Peter Velkov. All rights reserved.
//

import Foundation
import UIKit

class VideoResultCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivBackoundImage: UIImageView!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var btnOpen: UIButton!
    
    override func awakeFromNib() {
        btnOpen.addTarget(self, action: "logMe", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func logMe(){
        print("clicked");
    }
}