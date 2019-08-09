//
//  LocationTableViewCell.swift
//  Visits
//
//  Created by Jeffrey Curtis on 3/30/19.
//  Copyright © 2019 Jeffrey Curtis. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell{

    @IBOutlet weak var MapImage: UIImageView!
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var TextView: UITextView!
    @IBOutlet weak var BottomLabel: UILabel!
    var UID = UUID();
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
