//
//  cellDocumentView.swift
//  DocumentViewer
//
//  Created by piyush sinroja on 14/03/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit

class cellDocumentView: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
