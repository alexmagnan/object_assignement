//
//  LoadingViewTableCell.swift
//  Drawing
//
//  Created by Max Handelman on 2016-05-07.
//  Copyright © 2016 Chris Chadillon. All rights reserved.
//

import UIKit

class LoadingViewTableCell: UITableViewCell {

    @IBOutlet weak var drawingTitle: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
